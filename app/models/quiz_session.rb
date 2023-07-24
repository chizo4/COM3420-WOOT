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
class QuizSession < ApplicationRecord
  before_validation :generate_code, if: :new_record?

  belongs_to :quiz

  has_many :player_sessions, dependent: :destroy

  validates :code, presence: true, uniqueness: true

  def selected_answers
    player_sessions.map(&:selected_answer_list)
  end

  private

  # Method generates a unique session code for a quiz session.
  def generate_code
    loop do
      code = SecureRandom.alphanumeric(6).upcase
      break self.code = code unless QuizSession.exists?(code:)
    end
  end
end
