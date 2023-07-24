# frozen_string_literal: true

# == Schema Information
#
# Table name: quizzes
#
#  id          :bigint           not null, primary key
#  name        :string
#  public      :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  academic_id :bigint           not null
#  folder_id   :bigint
#
# Indexes
#
#  index_quizzes_on_academic_id  (academic_id)
#  index_quizzes_on_folder_id    (folder_id)
#
# Foreign Keys
#
#  fk_rails_...  (academic_id => academics.id)
#  fk_rails_...  (folder_id => folders.id)
#
class Quiz < ApplicationRecord
  default_scope { order(:name) }

  belongs_to :academic

  has_and_belongs_to_many :sharing, class_name: 'Academic', join_table: 'sharing_table'

  validates :name, presence: true, length: { maximum: 100 }
  validates :public, inclusion: { in: [true, false] }

  has_many :questions, dependent: :destroy
  has_many :quiz_sessions, dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: :all_blank

  def questions_length
    questions.length
  end
end
