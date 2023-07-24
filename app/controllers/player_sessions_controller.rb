# frozen_string_literal: true

class PlayerSessionsController < ApplicationController
  before_action :set_quiz_session, only: %i[new]
  before_action :set_player_session, only: %i[show destroy]
  after_action :send_stream, only: %i[create]
  before_action :set_answers, only: %i[show]

  def join; end

  def show; end

  def new
    @player_session = PlayerSession.new
  end

  def create
    @player_session = PlayerSession.new(player_session_params)

    if @player_session.save
      redirect_to @player_session
      flash[:notice] = 'Successfully joined the Quiz Session. Good luck!'
    else
      render :new, quiz_session_id: params[:quiz_session_id], status: :unprocessable_entity
    end
  end

  def destroy
    if @player_session.destroy
      flash[:notice] = 'Successfully left the Quiz Session.'
    else
      flash[:alert] = 'An error occured while you were leaving the Quiz Session.'
    end

    redirect_to root_path
  end

  # Method enables the players to join a session (provided that code is correct).
  def player_join
    code = params[:quiz_session][:code].strip
    @quiz_session = QuizSession.find_by(code:)

    if @quiz_session.present?
      redirect_to new_player_session_path(quiz_session_id: @quiz_session)
      flash[:notice] = 'Successfully joined the Quiz! Good luck!'
    else
      render :join, status: :unprocessable_entity
      flash[:notice] = 'Oops! We did not recognize the entered Game Code. Please try again!'
    end
  end

  private

  def set_quiz_session
    @quiz_session = QuizSession.find(params[:quiz_session_id])
    @quiz = Quiz.find(@quiz_session.quiz_id)
  end

  def set_player_session
    @player_session = PlayerSession.find(params[:id])
    @quiz_session = QuizSession.find(@player_session.quiz_session_id)
    @quiz = Quiz.find(@quiz_session.quiz_id)
  end

  def player_session_params
    params.require(:player_session).permit(
      :username, :quiz_session_id
    )
  end

  def set_answers
    @question = @quiz.questions.find_by(position: @quiz_session.position)

    return unless @question.present?

    @answers = @question.answers
  end

  def send_stream
    player_sessions = PlayerSession.where(
      quiz_session_id: @player_session.quiz_session_id
    )

    PgPubsub.new('event').publish(
      (Hash[:event, 'player_sessions', :players, player_sessions.to_json]).to_json
    )
  end
end
