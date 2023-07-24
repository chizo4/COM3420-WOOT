# frozen_string_literal: true

require 'rails_helper'

describe 'Visiting the show page of a Quiz instance' do
  let!(:academic) { build(:academic) }
  let!(:academic1) { build(:academic) }
  let!(:quiz) { create(:quiz, academic:) }
  let!(:question) { create(:question_with_answers, answers_count: 5, quiz:) }

  context 'as a logged in academic user' do
    before do
      login_as(academic1)
      quiz.sharing.append(academic1)
      visit academic_shared_path(academic1)
    end

    specify 'can see the quizzes shared with me' do
      expect(page).to have_content(quiz.name)
    end
  end
end
