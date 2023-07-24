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

FactoryBot.define do
  factory :question do
    association :quiz

    sequence(:content) { |i| "What is #{i}?" }
    sequence(:position, &:to_i)

    factory :question_with_answers do
      transient do
        answers_count { [*2..6].sample }
        correct_answer_index { 1 }
      end

      after(:build) do |question, evaluator|
        evaluator.answers_count.times do |i|
          answer = build(:answer, question:, correct: i == evaluator.correct_answer_index)
          question.answers << answer
        end
        question.save
      end
    end
  end
end

# FactoryBot.define do
#   factory :question do
#     association :quiz

#     sequence(:content) { |i| "What is #{i}?" }
#     sequence(:position, &:to_i)

#     factory :question_with_answers do
#       transient do
#         answers_count { [*2..6].sample }
#       end

#       answers do
#         Array.new(answers_count) do |i|
#           # Ensure that at least Answer object is correct.
#           i == 0 ? association(:answer, correct: true) : association(:answer)
#         end
#       end
#     end
#   end
# end
