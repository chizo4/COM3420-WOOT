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
require 'rails_helper'

RSpec.describe Quiz, type: :model do
  let!(:quiz) { create(:quiz) }
  let!(:question) { build(:question, quiz:) }
  let!(:question1) { build(:question, quiz:) }

  context 'validates quiz' do
    it 'is valid with a name and an academic (associated by default)' do
      expect(quiz).to be_valid
    end

    it 'is not valid without an academic (removed association)' do
      quiz.academic = nil
      expect(quiz).not_to be_valid
    end

    it 'is not valid without a name' do
      quiz.name = ''
      expect(quiz).not_to be_valid
    end

    it 'is not valid with a name exceeding the permitted length (100+ chars)' do
      quiz.name = (0...101).map { ('a'..'z').to_a[rand(26)] }.join
      expect(quiz).not_to be_valid
    end

    it 'returns the correct number of questions associated with it' do
      quiz.questions << Question.new
      expect(quiz.questions_length).to eq(1)
    end

    # it 'correctly updates position of questions when deleted' do
    #   pos = question1.position
    #   question.destroy
    #   expect(question1.position).to eq(pos - 1)
    # end
  end
end

# RSpec.describe Quiz, type: :model do
#   let!(:quiz) { create(:quiz) }
#   it 'updates the position of the questions correctly ' do
#     q1 = Question.create(position: 1, quiz:)
#     q2 = Question.create(position: 2, quiz:)
#     q3 = Question.create(position: 3, quiz:)
#     quiz.questions << q1
#     quiz.questions << q2
#     quiz.questions << q3
#     q2.destroy
#     expect(q3.position).to eq(2)
#   end
# end
