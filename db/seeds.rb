# frozen_string_literal: true

#
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# --------------------------------------------------------------------------------------------------------------------

# Setting constants
MAIN_ACADEMIC = Academic.where.not(username: 'test01').first
# Setting the random seed
srand(2153)

# --------------------------------------------------------------------------------------------------------------------
# Functions
def generate_answers
  num_answers = rand(1..5)
  correct_index = rand(0..num_answers)

  all_answer_params = []
  (0..num_answers).each do |i|
    if i == correct_index
      all_answer_params.append(content: 'true', correct: true)
    else
      all_answer_params.append(content: 'false', correct: false)
    end
  end
  all_answer_params
end

def generate_questions(quiz_local)
  num_questions = rand(1..15)

  q_index = 1
  while q_index <= num_questions
    Question.create!(content: "What is the answer? Q#{q_index}", position: q_index, quiz_id: quiz_local.id,
                     answers_attributes: generate_answers)
    q_index += 1
  end
end

# Runs main

# Creating Folders
folder_tech = Folder.create(name: 'Technology quizzes', academic_id: MAIN_ACADEMIC.id)
folder_geo = Folder.create(name: 'Geography quizzes', academic_id: MAIN_ACADEMIC.id)

# Creating Quizzes
# Main Test quiz
quiz = Quiz.create(name: 'Harry Potter Quiz', academic_id: MAIN_ACADEMIC.id)

Question.create(content: 'Is Harry a witch or a wizard?', position: 1, quiz_id: quiz.id,
                answers_attributes: [
                  { content: 'Witch', correct: false },
                  { content: 'Wizard', correct: true }
                ])

Question.create(content: 'Which one is not part of the Deathly Hallows?', position: 2, quiz_id: quiz.id,
                answers_attributes: [
                  { content: 'Resurrection stone', correct: false },
                  { content: 'Sword of gryffindor', correct: true },
                  { content: 'Elder wand', correct: false },
                  { content: 'Cape of invisibility', correct: false }
                ])

Question.create(content: 'Fun fact, Harry does not cast a spell in the first movie', position: 3,
                quiz_id: quiz.id,
                answers_attributes: [
                  { content: 'True', correct: true },
                  { content: 'False', correct: false }
                ])

Question.create(content: 'how many Horcruxes were there?', position: 4, quiz_id: quiz.id,
                answers_attributes: [
                  { content: '5', correct: false },
                  { content: '6', correct: false },
                  { content: '7', correct: true },
                  { content: '8', correct: false },
                  { content: '9', correct: false },
                  { content: '10', correct: false }
                ])

Question.create(content: 'Poll: On a scale of 1 to 5, what did you think of this quiz?', position: 5,
                quiz_id: quiz.id, poll: true,
                answers_attributes: [
                  { content: '1', correct: true },
                  { content: '2', correct: true },
                  { content: '3', correct: true },
                  { content: '4', correct: true },
                  { content: '5', correct: true }
                ])

# Question.create(content: 'Which one of these is a pub in Hogsmeade?', position: 6, quiz_id: quiz.id,
#                 answers_attributes: [
#                   { content: 'The Three Broomsticks', correct: true },
#                   { content: 'The Hog’s Bed', correct: false },
#                   { content: 'Crossed Wands', correct: false },
#                   { content: 'The Three Butterbeers', correct: false }
#                 ])

# Question.create(content: 'Where is the entrance to the chamber of secrets?', position: 7, quiz_id: quiz.id,
#                 answers_attributes: [
#                   { content: 'Moaning Myrtle’s bathroom', correct: true },
#                   { content: 'At the Shrieking Shack', correct: false }
#                 ])

# Question.create(content: 'How is mail delivered in the wizarding world?', position: 8, quiz_id: quiz.id,
#                 answers_attributes: [
#                   { content: 'Owl', correct: true },
#                   { content: 'Pigeon', correct: false },
#                   { content: 'Goat', correct: false },
#                   { content: 'Sheep', correct: false },
#                   { content: 'Bat', correct: false },
#                   { content: 'Dove', correct: false }
#                 ])

# Question.create(content: 'How does one ward off a Dementor?', position: 9, quiz_id: quiz.id,
#                 answers_attributes: [
#                   { content: 'Aberto', correct: false },
#                   { content: 'Accio', correct: false },
#                   { content: 'The Patronus Charm', correct: true },
#                   { content: 'Aparecium', correct: false }
#                 ])

# Question.create(content: 'In the wizarding world, speaking to snakes is a skill called what? ', position: 10,
#                 quiz_id: quiz.id,
#                 answers_attributes: [
#                   { content: 'Parseltongue', correct: true },
#                   { content: 'Snaketounge', correct: false },
#                   { content: 'Hisstounge', correct: false },
#                   { content: 'Scaletounge', correct: false }
#                 ])

# Question.create(content: 'Who is Harry Potter’s godfather?', position: 11, quiz_id: quiz.id,
#                 answers_attributes: [
#                   { content: 'Voldemort', correct: false },
#                   { content: 'Patrick Potter', correct: false },
#                   { content: 'Sirius Black', correct: true }
#                 ])

# Question.create(content: 'What is Luna Lovegood’s father’s name?', position: 12, quiz_id: quiz.id,
#                 answers_attributes: [
#                   { content: 'Xenophilius Lovegood', correct: true },
#                   { content: 'Richard Lovegood', correct: false },
#                   { content: 'Finch Lovegood', correct: false },
#                   { content: 'Jack Lovegood', correct: false },
#                   { content: 'Sphinx Lovegood', correct: false }
#                 ])

# Question.create(content: 'What position does Harry play on the Gryffindor Quidditch team?', position: 13,
#                 quiz_id: quiz.id,
#                 answers_attributes: [
#                   { content: 'chaser', correct: false },
#                   { content: 'seeker', correct: true },
#                   { content: 'beater', correct: false },
#                   { content: 'keeper', correct: false }
#                 ])

# --------------------------------------------------------------------------------------------------------------------

# Basic Geography Folder Quizzes
quiz = Quiz.create(name: 'Capitals Quiz 2', academic_id: MAIN_ACADEMIC.id, folder_id: folder_geo.id)
generate_questions(quiz)
quiz = Quiz.create(name: 'Countries Quiz', academic_id: MAIN_ACADEMIC.id, folder_id: folder_geo.id)
generate_questions(quiz)
quiz = Quiz.create(name: 'Countries Quiz 2', academic_id: MAIN_ACADEMIC.id, folder_id: folder_geo.id)
generate_questions(quiz)
quiz = Quiz.create(name: 'Coastal Places Quiz', academic_id: MAIN_ACADEMIC.id, folder_id: folder_geo.id)
generate_questions(quiz)
quiz = Quiz.create(name: 'Cities Quiz', academic_id: MAIN_ACADEMIC.id, folder_id: folder_geo.id)
generate_questions(quiz)
quiz = Quiz.create(name: 'London Architecture Quiz', academic_id: MAIN_ACADEMIC.id, folder_id: folder_geo.id)
generate_questions(quiz)

# Basic Technology Folder Quizzes
quiz = Quiz.create(name: 'GPU Quiz', academic_id: MAIN_ACADEMIC.id, folder_id: folder_tech.id)
generate_questions(quiz)
quiz = Quiz.create(name: 'CPU Quiz', academic_id: MAIN_ACADEMIC.id, folder_id: folder_tech.id)
generate_questions(quiz)
quiz = Quiz.create(name: 'Artificial Intelligence Quiz', academic_id: MAIN_ACADEMIC.id, folder_id: folder_tech.id)
generate_questions(quiz)
quiz = Quiz.create(name: 'Excel Quiz', academic_id: MAIN_ACADEMIC.id, folder_id: folder_tech.id)
generate_questions(quiz)

# Basic quizzes not in any Folder
quiz = Quiz.create(name: 'Youtube Quiz', academic_id: MAIN_ACADEMIC.id)
generate_questions(quiz)
quiz = Quiz.create(name: 'Chicken Run Quiz', academic_id: MAIN_ACADEMIC.id)
generate_questions(quiz)
quiz = Quiz.create(name: 'Shoe Quiz', academic_id: MAIN_ACADEMIC.id)
generate_questions(quiz)
quiz = Quiz.create(name: 'Radios Quiz', academic_id: MAIN_ACADEMIC.id)
generate_questions(quiz)
quiz = Quiz.create(name: 'Carpet Quiz', academic_id: MAIN_ACADEMIC.id)
generate_questions(quiz)

# --------------------------------------------------------------------------------------------------------------------

# Seeds test academic
test_academic = Academic.create(email: 'test@sheffield.ac.uk',
                                username: 'test01',
                                uid: 'test01',
                                mail: 'test@sheffield.ac.uk',
                                ou: 'COM',
                                sn: 'Blogs',
                                givenname: 'Joe')
quiz = Quiz.create(name: 'Sharing Quiz', academic_id: test_academic.id)
generate_questions(quiz)

# Share "Sharing Quiz" with MAIN_ACADEMIC
quiz.sharing << MAIN_ACADEMIC
