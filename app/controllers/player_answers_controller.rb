# frozen_string_literal: true

class PlayerAnswersController < ApplicationController
  def create
    @player_answer = PlayerAnswer.new(player_answer_params)
    @player_answer.save
  end

  def player_answer_params
    params.require(:player_answer).permit(
      :player_session_id, :answer_id, :time
    )
  end
end
