# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :content
      t.integer :position
      t.belongs_to :quiz, null: false, foreign_key: true

      t.timestamps
    end
    add_index :questions, %i[position quiz_id], unique: true
  end
end
