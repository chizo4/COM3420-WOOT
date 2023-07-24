# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  content    :string
#  poll       :boolean          default(FALSE)
#  position   :integer
#  time       :integer          default(10)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quiz_id    :bigint           not null
#
# Indexes
#
#  index_questions_on_position_and_quiz_id  (position,quiz_id)
#  index_questions_on_quiz_id               (quiz_id)
#
# Foreign Keys
#
#  fk_rails_...  (quiz_id => quizzes.id)
#
require 'rails_helper'

RSpec.describe Question, type: :model do
  let!(:question) { build(:question_with_answers) }
  let!(:bad_question1) { build(:question_with_answers, answers_count: 7) }
  let!(:bad_question2) { build(:question_with_answers, answers_count: 1) }

  context 'validates the question' do
    it 'is valid with quiz and 2-6 answers associations' do
      expect(question).to be_valid
    end

    it 'is not valid when there is no association with quiz' do
      question.quiz = nil
      expect(question).not_to be_valid
    end

    it 'is not valid when there is no content field' do
      question.content = nil
      expect(question).not_to be_valid
    end

    it 'is not valid when the content is over permitted length' do
      question.content = (0...251).map { ('a'..'z').to_a[rand(26)] }.join
      expect(question).not_to be_valid
    end

    it 'is not valid when there are less than 2 answers associated' do
      expect(bad_question1).not_to be_valid
    end

    it 'is not valid when there are more than 7 answers associated' do
      expect(bad_question2).not_to be_valid
    end

    it 'is valid to delete an answer from a question if there remains 1+ correct and 2+ answers' do
      question.answers.where(correct: false).sample.destroy
      expect(question).to be_valid
    end
  end
end
