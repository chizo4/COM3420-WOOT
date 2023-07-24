# frozen_string_literal: true

require 'rails_helper'

describe 'Visiting the show page of a Quiz instance' do
  let!(:academic) { build(:academic) }
  let!(:academic1) { build(:academic) }
  let!(:quiz) { create(:quiz, academic:) }
  let!(:question) { create(:question_with_answers, answers_count: 3, quiz:) }

  context 'as a logged in academic user' do
    before do
      login_as(academic)
      visit academic_quiz_path(quiz)
    end

    specify 'cannot share the quiz with invalid academic' do
      click_on 'Share'
      fill_in 'quiz_academic_email', with: 'efdwcx'
      click_on 'Share'
      expect(page).to have_content 'Unable to share the Quiz'
    end

    # specify 'can share the quiz with valid academic' do
    #     click_on 'Share'
    #     fill_in 'quiz_academic_email', with: academic1.email
    #     click_on 'Share'
    #     expect(page).to have_content 'Successfully shared the Quiz'
    # end

    specify 'cannot share the quiz with invalid academic' do
      quiz.sharing.append(academic1)
      click_on 'Share'
      expect(page).to have_content(academic1.name)
      expect(page).to have_content(academic1.email)
      click_on 'Delete'
      expect(page).to have_content 'Successfully un-shared the Quiz'
    end
  end
end
