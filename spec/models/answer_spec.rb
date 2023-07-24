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
require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:answer) { build(:answer) }

  context 'validates the answer' do
    it 'is valid with all fields and association with question' do
      expect(answer).to be_valid
    end

    it 'is not valid when it does not belong to a question' do
      answer.question = nil
      expect(answer).not_to be_valid
    end

    it 'is not valid when there is no content' do
      answer.content = nil
      expect(answer).not_to be_valid
    end

    it 'is not valid when the content is over permitted length' do
      str_len = 251
      answer.content = rand(36**str_len).to_s(36)
      expect(answer).not_to be_valid
    end
  end
end
