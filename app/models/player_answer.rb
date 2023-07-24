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
class PlayerAnswer < ApplicationRecord
  belongs_to :player_session
  belongs_to :answer

  after_create :update_score

  # Method updates the player's score during an ongoing quiz session.
  def update_score
    player_session = PlayerSession.find(player_session_id)
    answer = Answer.find(answer_id)
    question = Question.joins(:answers).where(answers: { id: answer_id }).first

    calc_score = (time / question.time * 1000)

    player_session.update(score: player_session.score + calc_score) if answer.correct && !answer.question.poll?
  end
end
