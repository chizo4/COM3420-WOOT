const eventSource = new EventSource('/events');

eventSource.addEventListener('update', function (event) {
    const eventName = JSON.parse(event.data)['event'];
    var checkSessionDiv = null;

    // Gets different objects depending on the event name
    if (eventName === 'quiz_session') {
        var quizObj = JSON.parse(JSON.parse(event.data)['quiz']);
        var questionObj = JSON.parse(JSON.parse(event.data)['question']);
        checkSessionDiv = document.getElementById(`quiz_session_${quizObj['id']}`);
    } else if (eventName === 'player_sessions') {
        var playersObj = JSON.parse(JSON.parse(event.data)['players']);
        checkSessionDiv = document.getElementById(`quiz_session_${playersObj[0]['quiz_session_id']}`);
    } else if (eventName === 'pause') {
        var quizObj = JSON.parse(JSON.parse(event.data)['quiz_session']);
        checkSessionDiv = document.getElementById(`quiz_session_${quizObj['id']}`);
    }

    // Checks that this only affects the intended view by checking on a div with specific id
    if (checkSessionDiv) {
        // Event for quiz_session#show.
        if (eventName === 'quiz_session') {
            try {
                const quizSessionDiv = document.getElementById('quiz-session-question');
                const waitingTitleDiv = document.getElementById('waiting-title');
                const leaderboardDiv = document.getElementById('leaderboard');
                const timerDiv = document.getElementById('timer');
                const countdownDiv = document.getElementById('countdown');
                const nextButtonDiv = document.getElementById('next-button-container');
                const pauseButtonDiv = document.getElementById('pause-button-container');
                const pauseButtonText = document.getElementById('pause-button-text');
                const pauseButtonIcon = document.getElementById('pause-button-icon');

                var currentQuestion = questionObj;
                var currentAnswers = questionObj.answers;
                
                // Constant functions to be reused
                const showTimer = () => {
                    timerDiv.classList.remove('d-none');
                    timerDiv.classList.add('d-block');
                }
                const hideTimer = () => {
                    timerDiv.classList.remove('d-block');
                    timerDiv.classList.add('d-none');
                }
                const showPauseButton = () => {
                    pauseButtonDiv.classList.remove('d-none');
                    pauseButtonDiv.classList.add('d-block');
                }
                const hidePauseButton = () => {
                    pauseButtonDiv.classList.remove('d-block');
                    pauseButtonDiv.classList.add('d-none');
                }
                const hideNextButton = () => {
                    nextButtonDiv.classList.add('d-none');
                }
                const showLeaderboard = () => {
                    leaderboardDiv.classList.remove('d-none');
                    leaderboardDiv.classList.add('d-block');
                }
                const hideLeaderboard = () => {
                    leaderboardDiv.classList.remove('d-block');
                    leaderboardDiv.classList.add('d-none');
                }
                const resetPauseButton = () => {
                    if (pauseButtonIcon.classList.contains('bi-play-circle-fill')) {
                        pauseButtonIcon.classList.remove('bi-play-circle-fill');
                        pauseButtonIcon.classList.add('bi-pause-circle-fill');
                        pauseButtonText.textContent = 'Pause  ';
                        countdownDiv.dataset.paused = quizObj.paused;   
                    }            
                }
                
                // Removes checks from all answers
                const ansArray = [];
                const ansArrayCheck = []
                for (let i = 1; i <= 6; i++) {
                    const currAnswer = document.getElementById(`answer${i}`);
                    const currCheck = document.getElementById(`answer${i}-check`);

                    currAnswer.classList.remove('d-block');
                    currAnswer.classList.add('d-none');
                    currCheck.classList.remove('bi-check');

                    ansArray.push(currAnswer);
                    ansArrayCheck.push(currCheck);
                }

                quizSessionDiv.replaceChildren();
                var newDiv = document.createElement('div');
                
                // Removes the background animation
                if (quizObj.position != 0) {
                    const waitingAnimation = document.getElementById('waiting-animation');
                    waitingAnimation.classList.remove('d-block');
                    waitingAnimation.classList.add('d-none');
                }
                
                if (quizObj.position === 0) {
                    newDiv.textContent = 'Waiting';
                    hideLeaderboard();
                    hideTimer();
                
                // Has to be here for lazy evaluation
                // Changes view to show the correct answers
                } else if ((quizObj.position % 1).toFixed(2) == 0.33) { 
                    newDiv.textContent = currentQuestion.content;
                    showTimer();
                    showPauseButton();
                    resetPauseButton();

                    let correctAnswers = [];
                    for (let i = 0; i < currentAnswers.length; i++) {
                        if (currentAnswers[i].correct) {
                            correctAnswers.push(currentAnswers[i]);
                        }
                    }

                    var selectedAnswersObj = JSON.parse(JSON.parse(event.data)['selected_answers']);
                    
                    // Calculates the total number of answers to display percentages
                    const counts = {};
                    let totalAns = 0;
                    for (const selAns of selectedAnswersObj) {
                        counts[selAns.id] = (counts[selAns.id] || 0) + 1;
                        totalAns++;
                    }
                    
                    // Gets the selected answer and amount of answers recorded
                    var selectedAnswers = Object.entries(counts).map(([num, count]) => [parseInt(num), count]);
                    
                    // Shows the percetanges of each answer
                    for (let i = 0;  i < currentAnswers.length; i++) {
                        let ans = currentAnswers[i];
                        ansArray[i].classList.remove('d-none');
                        ansArray[i].classList.add('d-block');
                        ansCount = findSubarray(selectedAnswers, ans.id);
                        
                        // Makes background transparent for incorrect answers
                        if (correctAnswers.includes(ans)) {
                            ansArrayCheck[i].classList.add('bi-check');
                        } else {
                            ansArray[i].classList.remove(`bg-answer${i+1}`);
                            ansArray[i].classList.add(`bg-answer${i+1}-t`);
                        }

                        let ansText = ansArray[i].querySelector('p');
                        let ansPercentage = 0;

                        if (totalAns > 0) {
                            ansPercentage =( ansCount[1] / totalAns * 100).toFixed(1);
                        } else {
                            ansPercentage = 0;
                        }

                        ansText.textContent = `${ans.content} ${ansPercentage}%`;
                    }

                    countdownDiv.dataset.value = 5;
                    countdownDiv.textContent = 5;

                // When quiz has finished
                } else if (quizObj.position > quizObj.quiz.questions_length) {
                    waitingTitleDiv.replaceChildren();
                    newDiv.textContent = 'Leaderboard';

                    // Start confetti animation
                    const confettiAnimation = document.getElementById('confetti-animation');
                    confettiAnimation.classList.remove('d-none');
                    confettiAnimation.classList.add('d-block');

                    hideNextButton();
                    hidePauseButton();
                    showLeaderboard();
                    hideTimer();
                } else if (quizObj.position % 1 === 0) {                     
                    waitingTitleDiv.replaceChildren();
                    showTimer();
                    showPauseButton();
                    hideLeaderboard();
                    resetPauseButton();

                    newDiv.textContent = `${currentQuestion.position}. ${currentQuestion.content}`;

                    // Set the text on answer buttons.
                    for (let i = 0;  i < currentAnswers.length; i++) {
                        let ans = currentAnswers[i];
                        ansArray[i].classList.remove('d-none');
                        ansArray[i].classList.add('d-block');
                        ansArray[i].classList.replace(`bg-answer${i+1}-t`,`bg-answer${i+1}`);
                        let ansText = ansArray[i].querySelector('p');
                        ansText.textContent = ans.content;
                    }
                    
                    // Countdown timer.
                    countdownDiv.dataset.paused = quizObj.paused;      
                    countdownDiv.dataset.value = currentQuestion.time;
                    countdownDiv.textContent = currentQuestion.time;
                
                // Shows leaderboard
                } else if ((quizObj.position % 1).toFixed(2) == 0.66) {
                    newDiv.textContent = 'Leaderboard';

                    showLeaderboard();
                    showTimer();
                    showPauseButton();
                    resetPauseButton();
                    
                    // Countdown timer
                    countdownDiv.dataset.paused = quizObj.paused;      
                    countdownDiv.dataset.value = 5;
                    countdownDiv.textContent = 5;
                } 

                quizSessionDiv.appendChild(newDiv);
            } catch (error) {
                // Note: Added for dev only.
                // console.log(error);
            }
        }

        // Event for player_session#show
        if (eventName === 'quiz_session') {
            try {
                const countdownDiv = document.getElementById('countdown');
                const fieldArray = [];
                const submitArray = [];
                const ansArray = [];
                var newDiv = document.createElement('div');
                
                const playerSessionContentDiv = document.getElementById('player-session-content');
                playerSessionContentDiv.classList.remove('d-block');
                playerSessionContentDiv.classList.add('d-none');

                const answerTitleDiv = document.getElementById('player-answer-title');
                answerTitleDiv.replaceChildren();

                const playerAnswerIcon = document.getElementById('player-answer-icon');
                playerAnswerIcon.classList.remove('d-block');
                playerAnswerIcon.classList.add('d-none');

                // Hides all answer buttons by default
                for (let i = 1; i <= 6; i++) {
                    var answerForm = document.getElementById(`answer${i}-form`);
                    var answerField = document.getElementById(`answer${i}-field`);
                    var answerSubmit = document.getElementById(`answer${i}-submit`);

                    answerForm.classList.remove('d-block');
                    answerForm.classList.add('d-none');
                    ansArray.push(answerForm);
                    fieldArray.push(answerField);
                    submitArray.push(answerSubmit);
                }

                if (quizObj.position === 0) {
                    newDiv.textContent = 'Waiting';
                    answerTitleDiv.appendChild(newDiv);
                
                // Shows corresponding answer buttons
                } else if (quizObj.position % 1 === 0) {
                    newDiv.textContent = 'Select the correct answer';
                    answerTitleDiv.appendChild(newDiv);

                    var currentQuestion = questionObj;
                    var currentAnswers = questionObj.answers;
                    const answersList = document.getElementById('answers-list');
                    const answersGrid = document.getElementById('answers-grid');

                    newDiv.textContent = `Q${currentQuestion.position}. Select the correct answer:`;
                    answerTitleDiv.appendChild(newDiv);
                    
                    if (answersList.classList.contains('d-none')) {
                        answersList.classList.remove('d-none');
                        answersList.classList.add('d-block');
                    }
                    
                    if (answersGrid.classList.contains('row-cols-2') && currentAnswers.length <= 3) {
                        answersGrid.classList.remove('row-cols-2');
                        answersGrid.classList.add('row-cols-1');
                    } else if (answersGrid.classList.contains('row-cols-1') && currentAnswers.length > 3) {
                        answersGrid.classList.remove('row-cols-1');
                        answersGrid.classList.add('row-cols-2');
                    }

                    // Set display on answer buttons and hidden fields for each answer.
                    for(let i = 0;  i < currentAnswers.length; i++) {
                        ansArray[i].classList.remove('d-none');
                        ansArray[i].classList.add('d-block');

                        let ans = currentAnswers[i];
                        fieldArray[i].value = ans.id
                    }

                    countdownDiv.dataset.paused = quizObj.paused;      
                    countdownDiv.dataset.value = currentQuestion.time;

                // Removes all answers while correct answer and leaderboard are being displayed
                } else if (quizObj.position % 1 != 0){
                    const answersList = document.getElementById('answers-list');

                    if (answersList.classList.contains('d-block')) {
                        answersList.classList.remove('d-block');
                        answersList.classList.add('d-none');
                    }

                    countdownDiv.dataset.value = -1;
                    playerSessionContentDiv.classList.remove('d-none');
                    playerSessionContentDiv.classList.add('d-block');
                } else if (quizObj.position > quizObj.quiz.questions_length) {
                    newDiv.textContent = 'End of Quiz';
                    answerTitleDiv.appendChild(newDiv);
                }
            } catch (error) {
                // Note: Added for dev only.
                // console.log(error);
            }
        }

        // Event for player_session#show
        if (eventName === 'player_sessions'){
            try {
                // Iterates through each player to find the appropriate for each view
                // Shows correctness of answer
                playersObj.forEach(player => {
                    const answerCorrectDiv = document.getElementById(`answer_correct_${player['id']}`);
                    const answerCorrectIconDiv = document.getElementById(`answer_correct_icon_${player['id']}`);
                    const playerPointsDiv = document.getElementById(`player_points_${player['id']}`);
                    
                    // Looks for the correct player depending on div id
                    if (answerCorrectDiv && playerPointsDiv) {
                        answerCorrectDiv.replaceChildren();
                        playerPointsDiv.replaceChildren();
                        
                        // Adds icon, text and score depending on if answer correct/incorrect/no answer
                        if (answerCorrectIconDiv.classList.contains('bi-check-circle-fill')) {
                            answerCorrectIconDiv.classList.remove('bi-check-circle-fill');
                        } else if (answerCorrectIconDiv.classList.contains('bi-x-circle-fill')) {
                            answerCorrectIconDiv.classList.remove('bi-x-circle-fill');
                        } else if (answerCorrectIconDiv.classList.contains('bi-hand-thumbs-down-fill')) {
                            answerCorrectIconDiv.classList.remove('bi-hand-thumbs-down-fill');
                        }
                    
                        if (player.selected_answer === 'None') {
                            answerCorrectIconDiv.classList.add('bi-hand-thumbs-down-fill');
                            answerCorrectDiv.textContent = ' You did not answer. ';
                        } else if (player.selected_answer){
                            answerCorrectIconDiv.classList.add('bi-check-circle-fill');
                            answerCorrectDiv.textContent = ' Your answer is correct. ';
                        } else {
                            answerCorrectIconDiv.classList.add('bi-x-circle-fill');
                            answerCorrectDiv.textContent = ' Your answer is incorrect. ';
                        }
                    
                        playerPointsDiv.textContent = `Your points: ${player.score}`;
                    }
                });

            } catch (error) {
                // Note: Added for dev only.
                // console.log(error);
            }
        }

        // Event for player_sessions in quiz_session#show
        if (eventName === 'player_sessions'){
            try {
                const playerCountDiv = document.getElementById('player-count');
                const leaderboardTable = document.getElementById('leaderboard-table');

                playerCountDiv.replaceChildren();
                
                // Add the player count.
                var countDiv = document.createElement('div');
                countDiv.textContent = playersObj.length;
                playerCountDiv.appendChild(countDiv);
                
                playersObj.sort(function(a, b) {
                    return b.score - a.score;
                });

                // Reset leaderboard.
                for (var i = leaderboardTable.rows.length - 1; i >= 1; i--) {
                    // If the row index is 1 or greater, remove the row.
                    leaderboardTable.deleteRow(i);
                }
                
                // List player sessions.
                var count = 1;

                // Make sure to display the top 10 players.
                topPlayers = playersObj.slice(0, 10);
                topPlayers.forEach(player => {
                    // Create an empty <tr> element and add it to the 1st position of the table:
                    var row = leaderboardTable.insertRow(count);
                    row.setAttribute('scope', 'row');
                    row.classList.add('align-middle');
                    row.classList.add('text-center');

                    if (count % 2 != 0) {
                        row.classList.add('bg-white');
                    } else {
                        row.classList.add('bg-light');
                    } 

                    // Insert new cells (<td> elements) at the 1st and 2nd position of the "new" <tr> element:
                    var position = row.insertCell(0);
                    var username = row.insertCell(1);
                    var score = row.insertCell(2);

                    // Add some text to the new cells:
                    position.textContent = count;
                    username.textContent = player.username; 
                    score.textContent = player.score;

                    count++;
                });
            } catch (error) {
                // Note: Added for dev only.
                // console.log(error);
            }
        }

        if (eventName === 'pause') {
            try {
                const countdownDiv = document.getElementById('countdown');
                countdownDiv.dataset.paused = quizObj.paused;   
            } catch (error) {

            }
        }
    }

    // Helper method to find subarray given a number. Returns a tuple
    function findSubarray(arr, num) {
        for (const subarray of arr) {
        if (subarray[0] === num) {
            return subarray;
        }
        }
        
        return [0,0];
    }
});
