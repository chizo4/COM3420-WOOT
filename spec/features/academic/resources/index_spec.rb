# frozen_string_literal: true

require 'rails_helper'

describe 'Visiting the resources page' do
  let!(:academic) { build(:academic) }
  let!(:quiz) { create(:quiz, academic:) }
  let!(:folder) { create(:folder, academic:, name: 'folder123') }
  let!(:quiz1) { create(:quiz, academic:, folder_id: folder.id) }
  let!(:answer) { create(:answer, question:) }
  let!(:question) { create(:question_with_answers, answers_count: 3) }

  context 'as a logged in academic user' do
    before do
      login_as(academic)
      visit academic_resources_path
    end

    specify 'can see the academic name, unassociated quiz and folder' do
      expect(page).to have_content(academic.name)
      expect(page).to have_content(quiz.name)
      expect(page).to have_content(folder.name)
    end

    specify 'can see the action buttons' do
      expect(page).to have_link('Create Quiz')
      expect(page).to have_link('Create Folder')
    end

    specify 'can create a new quiz with correct name' do
      click_on 'Create Quiz'
      fill_in 'quiz_name', with: 'QuizABCD123'
      click_on 'Create'
      expect(page).to have_content('QuizABCD123')
    end

    specify 'can create a new folder with correct name' do
      click_on 'Create Folder'
      fill_in 'folder_name', with: 'FolderABCD123'
      click_on 'Create'
      expect(page).to have_content('FolderABCD123')
    end

    # specify 'can create a new folder with correct name' do
    #     click_on quiz.name
    #     save_and_open_page
    #     expect(page).to have_content('Successfully deleted the Quiz')
    # end

    specify 'cannot create a new quiz with empty name' do
      click_on 'Create Quiz'
      fill_in 'quiz_name', with: ''
      click_on 'Create'
      expect(page).to have_content('Name can\'t be blank')
    end

    specify 'cannot create a new folder with empty name' do
      click_on 'Create Folder'
      fill_in 'folder_name', with: ''
      click_on 'Create'
      expect(page).to have_content('Name can\'t be blank')
    end

    specify 'cannot create a new quiz with long name' do
      click_on 'Create Quiz'
      name = 'A' * 101
      fill_in 'quiz_name', with: name
      click_on 'Create'
      expect(page).to have_content('Name is too long')
    end

    specify 'cannot create a new folder with long name' do
      click_on 'Create Folder'
      name = 'A' * 101
      fill_in 'folder_name', with: name
      click_on 'Create'
      expect(page).to have_content('Name is too long')
    end

    specify 'deleting quiz correctly deletes it' do
      click_on 'Delete'
      expect(page).to have_content('Successfully deleted the Quiz')
    end

    specify 'deleting a folder' do
      find_by_id("DelRes#{folder.id}").click
      expect(page).to have_content('Successfully deleted the Folder')
    end

    specify 'searching for a quiz which exists' do
      fill_in 'query', with: quiz.name
      find_by_id('Search').click
      expect(page).to have_content(quiz.name)
      expect(page).not_to have_content(folder.name)
    end

    specify 'searching for a quiz which does not exists' do
      fill_in 'query', with: 'qwerty'
      find_by_id('Search').click
      expect(page).to have_content('There are no quizzes matching the current search')
    end
  end
end
