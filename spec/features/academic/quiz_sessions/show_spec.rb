# frozen_string_literal: true

require 'rails_helper'

describe 'Visiting the resources page', js: true do
  let!(:academic) { build(:academic) }
  let!(:quiz) { create(:quiz, academic:) }
  let!(:question) { create(:question_with_answers, answers_count: 3, quiz:, time: 60) }
  let!(:question1) { create(:question_with_answers, answers_count: 2, quiz:) }
  let!(:quiz_session) { create(:quiz_session, quiz:) }
  let!(:player_session) { create(:player_session, quiz_session:) }
  let!(:player_session1) { create(:player_session, quiz_session:) }

  context 'as a logged in academic user' do
    before do
      login_as(academic)
      visit academic_quiz_session_path(quiz_session)
    end

    specify 'can see the correct details' do
      expect(page).to have_content(quiz_session.code)
    end

    # specify 'can see the correct details' do
    #   click_on 'Next'
    #   expect(page).to have_content(question.content)
    #   expect(page).to have_content(question.answers.first.content)
    # end

    specify 'can end the quiz at any time' do
      click_on 'End'
      click_on 'Confirm'
      expect(page).to have_content('The Quiz Session got successfully stopped')
      expect(page).to have_current_path(academic_quiz_path(quiz))
    end

    specify 'can pause the timer' do
      click_on 'Next'
      find_by_id('pause-button').click
      quiz_session.paused
      expect(page).to have_content(question.time)
    end

    # specify 'can view the leaderboard and verify three stages' do
    #   find_by_id('next-button').click
    #   find_by_id('next-button').click
    #   find_by_id('next-button').click
    #   expect(page).to have_content('Leaderboard')
    # end

    # specify 'can view the next question' do
    #   find_by_id('next-button').click
    #   find_by_id('next-button').click
    #   find_by_id('next-button').click
    #   find_by_id('next-button').click
    #   expect(page).to have_content(question1.content)
    # end
  end
end
