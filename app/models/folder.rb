# frozen_string_literal: true

# == Schema Information
#
# Table name: folders
#
#  id          :bigint           not null, primary key
#  name        :string
#  academic_id :bigint           not null
#
# Indexes
#
#  index_folders_on_academic_id  (academic_id)
#
# Foreign Keys
#
#  fk_rails_...  (academic_id => academics.id)
#
class Folder < ApplicationRecord
  belongs_to :academic

  has_many :quizzes, dependent: :destroy
  validates :name, presence: true, length: { maximum: 100 }
end
