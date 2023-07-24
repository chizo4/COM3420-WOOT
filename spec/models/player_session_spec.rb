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
require 'rails_helper'

RSpec.describe PlayerSession, type: :model do
end
