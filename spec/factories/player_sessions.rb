# frozen_string_literal: true

# == Schema Information
#
# Table name: player_sessions
#
#  id              :bigint           not null, primary key
#  score           :integer          default(0)
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  quiz_session_id :bigint           not null
#
# Indexes
#
#  index_player_sessions_on_quiz_session_id  (quiz_session_id)
#
# Foreign Keys
#
#  fk_rails_...  (quiz_session_id => quiz_sessions.id)
#
FactoryBot.define do
  factory :player_session do
    sequence(:id, &:to_i)
    sequence(:username) { |i| "user-#{i}" }

    association :quiz_session
  end
end
