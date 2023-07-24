# frozen_string_literal: true

require 'rails_helper'

describe 'Visiting the show page of a Quiz instance' do
  let!(:academic) { build(:academic) }
  let!(:quiz) { create(:quiz, academic:) }

  context 'as a logged in academic user' do
    before do
      login_as(academic)
      visit new_academic_quiz_question_path(quiz)
    end

    specify 'check that there are no questions' do
      expect(page).to have_content('Create Question')
      expect(page).to have_field('Time', with: '10')
      expect(page).to have_field('Poll', checked: false)
      expect(page).to have_content('Answers')
    end

    specify 'cannot create question with empty content' do
      fill_in 'question_content', with: ''
      click_on 'Create'
      expect(page).to have_content('Content can\'t be blank')
    end

    specify 'cannot create question with content that exceeds limit' do
      con = '0' * 251
      fill_in 'question_content', with: con
      click_on 'Create'
      expect(page).to have_content('Content is too long')
    end

    specify 'cannot create quiz with time of 0s or less' do
      fill_in 'question_content', with: 'Hello World'
      fill_in 'Time', with: 0
      click_on 'Create'
      expect(page).to have_content('Time must be greater than 0')
    end

    specify 'creating a quiz with valid details' do
      fill_in 'question_content', with: 'Hello World'
      click_on 'Add answer'
      fill_in 'question_answers_attributes_0_content', with: 'Answer1'
      find_by_id('answer_correct_1').set(true)
      click_on 'Add answer'
      fill_in 'question_answers_attributes_1_content', with: 'Answer2'
      find_by_id('answer_correct_2').set(false)
      click_on 'Create'
      expect(page).to have_content('Successfully created new Question')
    end

    specify 'creating a poll with valid details' do
      fill_in 'question_content', with: 'Rate this quiz'
      click_on 'Add answer'
      fill_in 'question_answers_attributes_0_content', with: '1'
      click_on 'Add answer'
      fill_in 'question_answers_attributes_1_content', with: '2'
      find_by_id('question_poll').set(true)
      click_on 'Create'
      expect(page).to have_content('Successfully created new Question')
    end
  end
end
