# frozen_string_literal: true

class RemoveUniqueConstraintFromQuestionsPosition < ActiveRecord::Migration[7.0]
  def change
    remove_index :questions, column: %i[position quiz_id]
    add_index :questions, %i[position quiz_id]
  end
end
