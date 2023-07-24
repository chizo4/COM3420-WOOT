# frozen_string_literal: true

# == Schema Information
#
# Table name: player_answers
#
#  id                :bigint           not null, primary key
#  time              :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  answer_id         :bigint           not null
#  player_session_id :bigint           not null
#
# Indexes
#
#  index_player_answers_on_answer_id          (answer_id)
#  index_player_answers_on_player_session_id  (player_session_id)
#
# Foreign Keys
#
#  fk_rails_...  (answer_id => answers.id)
#  fk_rails_...  (player_session_id => player_sessions.id)
#
require 'rails_helper'

RSpec.describe PlayerAnswer, type: :model do
end
