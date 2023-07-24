# frozen_string_literal: true

require 'rails_helper'

describe 'Visiting the edit page of a Quiz question' do
  let!(:academic) { build(:academic, id: 1) }
  let!(:quiz) { create(:quiz, academic:) }
  let!(:question) { create(:question_with_answers, answers_count: 6, quiz:, quiz_id: quiz.id) }

  context 'as a logged in academic user' do
    before do
      login_as(academic)
      visit "/academic/quizzes/#{quiz.id}/questions/#{question.id}/edit"
    end

    specify 'expect modal to render correctly' do
      expect(page).to have_content('Update Question')
    end
  end
end
