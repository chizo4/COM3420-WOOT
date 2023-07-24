# frozen_string_literal: true

require 'rails_helper'

describe 'Visiting the show page of a Quiz instance', js: true do
  let!(:academic) { build(:academic) }
  let!(:quiz) { create(:quiz, academic:) }
  let!(:question) { create(:question_with_answers, answers_count: 3, quiz:) }
  let!(:questionTwo) { create(:question_with_answers, answers_count: 3, quiz:) }
  let!(:bad_quiz) { create(:quiz, academic:) }

  context 'as a logged in academic user' do
    before do
      login_as(academic)
      visit academic_quiz_path(quiz)
    end

    specify 'can see the quiz name' do
      expect(page).to have_content(quiz.name)
    end

    specify 'can see the action buttons' do
      expect(page).to have_link('Add')
      expect(page).to have_link('Start')
      expect(page).to have_link('Preview')
      expect(page).to have_button('Delete')
      expect(page).to have_link('Share')
      expect(page).to have_link('Settings')
    end

    specify 'correctly updates quiz name' do
      click_on 'Settings'
      fill_in 'quiz_name', with: 'abcd123'
      click_on 'Update'
      expect(page).to have_content('abcd123')
    end

    specify 'does not allow empty quiz name' do
      click_on 'Settings'
      fill_in 'quiz_name', with: ''
      click_on 'Update'
      expect(page).to have_content('Name can\'t be blank')
    end

    specify 'sucessfully previews the quiz if it has questions' do
      click_on 'Preview'
      expect(page).to have_current_path(academic_quiz_preview_path(quiz))
    end

    specify 'correctly updates the question name' do
      click_on 'Edit'
      fill_in 'question_content', with: 'New Name'
      click_on 'Update'
      expect(page).to have_content 'Successfully updated the Question'
    end

    specify 'correctly deletes the question' do
      find_by_id("DelQ#{question.id}").click
      click_on 'Confirm'
      expect(page).to have_content 'Successfully deleted the Question'
    end

    specify 'does not preview the quiz if it doesn\'t have questions' do
      visit academic_quiz_path(bad_quiz)
      click_on 'Preview'
      expect(page).to have_content('Could not start the Quiz Preview')
    end

    specify 'correctly adds a new question' do
      click_on 'Add'
      fill_in 'question_content', with: 'New Question name'
      click_on 'Add answer'
      fill_in 'question_answers_attributes_0_content', with: 'Answer 1'
      click_on 'Add answer'
      fill_in 'question_answers_attributes_1_content', with: 'Answer 2'
      find('#answer_correct_2').click
      click_on 'Create'
      expect(page).to have_content 'Successfully created new Question'
    end

    specify 'cannot update invalid question' do
      click_on 'Edit'
      fill_in 'question_content', with: ''
      click_on 'Update'
      expect(page).to have_content 'errors'
    end

    specify 'does not start the quiz if it doesn\'t have questions' do
      visit academic_quiz_path(bad_quiz)
      click_on 'Start'
      expect(page).to have_content('Could not start the Quiz Session, since the Quiz is not complete')
    end

    specify 'does start the quiz if it is valid' do
      click_on 'Start'
      expect(page).to have_content('The Quiz Session has successfully started')
    end

    # specify 'successfully deleting an answer' do
    #   visit edit_academic_quiz_question_path(quiz, question)
    #   find_by_id("DelAns3").click
    #   click_on 'Update'
    #   expect(page).to have_content('Successfully updated the Question')
    # end

    # specify 'successfully adding an answer' do
    #   visit edit_academic_quiz_question_path(quiz, question)
    #   find_by_id("AddAns").click
    #   fill_in 'Answer 4', with: 'Answer4'
    #   find("#Correct4").click
    #   click_on 'Update'
    #   expect(page).to have_content('Successfully updated the Question')
    # end

    specify 'can see the question' do
      expect(page).to have_content(question.content)
    end
  end
end
