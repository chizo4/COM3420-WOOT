# frozen_string_literal: true

require 'rails_helper'

describe 'Visiting the show page of a Folder instance' do
  let!(:academic) { build(:academic) }
  let!(:folder) { create(:folder, academic:, name: 'folder123') }
  let!(:quiz) { create(:quiz, academic:, folder_id: folder.id) }
  let!(:question) { create(:question_with_answers, answers_count: 2, quiz_id: quiz.id) }

  context 'as a logged in academic user' do
    before do
      login_as(academic)
      visit academic_folder_path(folder)
    end

    specify 'can see the folder and quiz name' do
      expect(page).to have_content(folder.name)
      expect(page).to have_content(quiz.name)
    end

    specify 'correctly updates folder name' do
      click_on 'Settings'
      fill_in 'folder_name', with: 'abcd123'
      click_on 'Update'
      expect(page).to have_content('abcd123')
    end

    specify 'does not allow empty folder name' do
      click_on 'Settings'
      fill_in 'folder_name', with: ''
      click_on 'Update'
      expect(page).to have_content('Name can\'t be blank')
    end

    specify 'Deleting quiz belonging to the folder leads back to folder page' do
      visit academic_quiz_path(quiz)
      find_by_id('DelQuiz').click
      expect(page).not_to have_content(quiz.name)
      expect(page).to have_current_path(academic_folder_path(folder))
    end

    specify 'searching for a quiz which exists' do
      fill_in 'query', with: quiz.name
      find_by_id('Search').click
      expect(page).to have_content(quiz.name)
    end
  end
end
