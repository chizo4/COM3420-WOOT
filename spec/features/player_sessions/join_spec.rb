# frozen_string_literal: true

require 'rails_helper'

describe 'Visiting the resources page', js: true do
  let!(:academic) { build(:academic) }
  let!(:quiz) { create(:quiz, academic:) }
  let!(:question) { create(:question_with_answers, answers_count: 3, quiz:, time: 60) }
  let!(:question1) { create(:question_with_answers, answers_count: 2, quiz:) }
  let!(:quiz_session) { create(:quiz_session, quiz:) }
  let!(:player_session) { create(:player_session, quiz_session:) }

  context 'as a player' do
    before do
      visit root_path
    end

    specify 'can join the quiz using valid session code' do
      fill_in 'quiz_session_code', with: quiz_session.code
      click_on 'Join'
      expect(page).to have_content('Successfully joined the Quiz!')
    end

    specify 'cannot join the quiz using invalid session code' do
      fill_in 'quiz_session_code', with: 'ABCDEF'
      click_on 'Join'
      click_on 'Join'
      expect(page).to have_content('Oops! We did not recognize the entered Game Code. Please try again!')
      expect(page).to have_current_path(root_path)
    end
  end
end
