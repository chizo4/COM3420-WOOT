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
FactoryBot.define do
  factory :quiz do
    sequence(:id, &:to_i)
    sequence(:name) { |i| "Quiz-#{i}" }

    association :academic
  end
end
