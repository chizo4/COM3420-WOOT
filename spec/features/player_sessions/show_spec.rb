# frozen_string_literal: true

require 'rails_helper'

describe 'Visiting the resources page', js: true do
  let!(:academic) { build(:academic) }
  let!(:quiz) { create(:quiz, academic:) }
  let!(:question1) { create(:question_with_answers, answers_count: 3, quiz:, time: 60) }
  let!(:question2) { create(:question_with_answers, answers_count: 3, quiz:, time: 60) }
  let!(:question3) { create(:question_with_answers, answers_count: 3, quiz:, time: 60) }
  let!(:quiz_session) { create(:quiz_session, quiz:) }
  let!(:player_session) { create(:player_session, quiz_session:) }

  context 'as a player' do
    before do
      login_as(academic)
      visit academic_quiz_session_path(quiz_session)
      expect(page).to have_content('Join at:')
      find_by_id('next-button').click
      expect(page).to have_content('Pause')
      visit "/player_sessions/#{player_session.id}"
    end

    specify 'can see the question answering page' do
      expect(page).to have_content('Q1. Select the correct answer')
    end

    specify 'can see the second question after three rounds' do
      visit academic_quiz_session_path(quiz_session)
      expect(page).to have_content('Next')
      find_by_id('next-button').click
      expect(has_css?('div.bi-check', count: 1)).to eq true
      find_by_id('next-button').click
      expect(page).to have_content('Leaderboard')
      find_by_id('next-button').click
      expect(page).to have_content('2.')
      visit "/player_sessions/#{player_session.id}"
      expect(page).to have_content('Q2. Select the correct answer')
    end

    specify 'can select an answer' do
      expect(page).to have_content('Q1. Select the correct answer')
      find_by_id('answer1-submit').click
    end

    # specify 'answering a question correctly' do
    #   find_by_id('answer1-submit').click
    #   visit academic_quiz_session_path(quiz_session)
    #   expect(page).to have_content('Next')
    #   find_by_id('next-button').click
    #   expect(has_css?('div.bi-check', count: 1)).to eq true
    #   find_by_id('next-button').click
    #   expect(page).to have_content('Leaderboard')
    #   visit "/player_sessions/#{player_session.id}"
    #   expect(page).to have_content('Your answer is correct.')
    # end
    #
    # specify 'answering a question incorrectly' do
    #   expect(page).to have_content('Q1. Select the correct answer')
    #   find_by_id('answer2-submit').click
    #   visit academic_quiz_session_path(quiz_session)
    #   expect(page).to have_content('End')
    #   find_by_id('next-button').click
    #   find_by_id('pause-button-text').click
    #   expect(page).to have_content('Leaderboard')
    #   visit "/player_sessions/#{player_session.id}"
    #   expect(page).to have_content('Your answer is correct.')
    # end
  end
end
