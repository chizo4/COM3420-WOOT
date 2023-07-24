# frozen_string_literal: true

require 'rails_helper'

describe 'Visiting the resources page', js: true do
  let!(:academic) { build(:academic) }
  let!(:quiz) { create(:quiz, academic:) }
  let!(:question) { create(:question_with_answers, answers_count: 3, quiz:) }
  let!(:question1) { create(:question_with_answers, answers_count: 2, quiz:) }
  let!(:quiz_session) { create(:quiz_session, quiz:) }
  let!(:player_session) { create(:player_session, quiz_session:) }

  context 'as a player' do
    before do
      #   visit player_sessions_path(quiz_session)
      login_as(academic)
      visit root_path
      fill_in 'quiz_session_code', with: quiz_session.code
      click_on 'Join'
    end

    specify 'cannot enter the quiz playing page with blank nickname' do
      fill_in 'player_session_username', with: ''
      click_on 'Let\'s Play!'
      expect(page).to have_content('Username can\'t be blank')
    end

    specify 'cannot enter banned words' do
      fill_in 'player_session_username', with: 'stupid123'
      click_on 'Let\'s Play!'
      expect(page).to have_content('Waiting')
    end

    specify 'can enter with same nicknames but still unique' do
      fill_in 'player_session_username', with: player_session.username
      click_on 'Let\'s Play!'
      expect(page).to have_content('Waiting')
    end

    specify 'can enter with same nicknames but still unique' do
      fill_in 'player_session_username', with: 'Hello'
      click_on 'Let\'s Play!'
      expect(page).to have_content('Successfully joined the Quiz Session')
    end
  end
end
