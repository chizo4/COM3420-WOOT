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
class PlayerSession < ApplicationRecord
  BANNED_WORDS = %w[
    ass bitch butt cock cunt dick dumb fuck jerk nonce piss pedo penis prick pussy sex shit slut stupid wank whore
  ].freeze

  before_validation :generate_unique_username, if: :new_record?

  belongs_to :quiz_session

  has_many :player_answers, dependent: :destroy

  validates :username, presence: true, uniqueness: { scope: :quiz_session_id }
  validate :filter_username_for_profanity

  def selected_answer_list
    if answered?
      Answer.find(player_answers.last.answer_id)
    else
      'None'
    end
  end

  def answered?
    current_question = quiz_session.quiz.questions.find_by(position: quiz_session.position)
    last_answer = player_answers.last

    # Checks if the last answer is included in the current answer set
    if last_answer.present? && current_question.present?
      answered = current_question.answers.pluck(:id).include? last_answer.answer_id
    end

    answered
  end

  private

  def filter_username_for_profanity
    # If a username includes a word from the banned list, then it is filtered with '*'.
    BANNED_WORDS.each do |word|
      username.gsub!(/#{Regexp.escape(word)}/i, '*' * word.length) if username.downcase.include?(word)
    end
  end

  def generate_unique_username
    return unless username.present? && quiz_session.present?

    existing_usernames = quiz_session.player_sessions.pluck(:username)
    username_suffix = username

    loop do
      break unless existing_usernames.include?(username_suffix)

      username_suffix = "#{username}##{username_suffix[/\d+/].to_i + 1}"
    end

    self.username = username_suffix
  end

  def selected_answer
    if answered?
      Answer.find(player_answers.last.answer_id).correct
    else
      'None'
    end
  end
end
