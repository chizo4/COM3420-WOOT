# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id          :bigint           not null, primary key
#  content     :string
#  correct     :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint           not null
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
class Answer < ApplicationRecord
  before_destroy :check_answers_count_and_correctness

  default_scope { order(:content) }

  belongs_to :question

  has_many :player_answers, dependent: :destroy

  validates :content, presence: true, length: { maximum: 100 }
  validates :correct, inclusion: { in: [true, false] }

  private

  def check_answers_count_and_correctness
    remaining_answers = question.answers.where.not(id:)
    return if remaining_answers.count > 1 && remaining_answers.any?(&:correct?)

    throw :abort
  end
end
