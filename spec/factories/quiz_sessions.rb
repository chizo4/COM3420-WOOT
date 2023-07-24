# frozen_string_literal: true

# == Schema Information
#
# Table name: quiz_sessions
#
#  id         :bigint           not null, primary key
#  code       :string
#  paused     :boolean
#  position   :float            default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quiz_id    :bigint           not null
#
# Indexes
#
#  index_quiz_sessions_on_code     (code) UNIQUE
#  index_quiz_sessions_on_quiz_id  (quiz_id)
#
# Foreign Keys
#
#  fk_rails_...  (quiz_id => quizzes.id)
#
FactoryBot.define do
  factory :quiz_session do
    sequence(:id, &:to_i)
    code { 'AAAAAA' }

    association :quiz
  end
end
