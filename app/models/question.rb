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
class Question < ApplicationRecord
  before_validation :set_position, on: :create
  before_destroy :set_questions
  after_destroy :update_positions
  after_save :set_poll_answers_correct, if: :poll?

  default_scope { order(:position) }

  belongs_to :quiz

  has_many :answers, dependent: :delete_all
  accepts_nested_attributes_for :answers, allow_destroy: true, reject_if: :all_blank

  validate :answers_count
  validate :answers_correctness
  validates :content, presence: true, length: { maximum: 250 }
  validates :position, presence: true, numericality: { greater_than: 0 }
  validates :time, presence: true, numericality: { greater_than: 0 }
  validates :poll, inclusion: { in: [true, false] }

  private

  def answers_count
    errors.add(:answers, 'must have between 2 and 6 answers.') unless answers.size.between?(2, 6)
  end

  def answers_correctness
    return if answers.any?(&:correct?)

    errors.add(:answers, 'must have at least one correct answer')
  end

  def set_poll_answers_correct
    answers.update_all(correct: true)
  end

  def set_position
    questions = Question.where(quiz_id:)
    self.position = questions.length + 1
  end

  def set_questions
    @questions = Question.where(quiz_id:).where('position > ?', position)
  end

  def update_positions
    @questions.each do |q|
      position = q.position - 1
      q.update(position:)
    end
  end
end
