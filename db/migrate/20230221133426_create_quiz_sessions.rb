# frozen_string_literal: true

class CreateQuizSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :quiz_sessions do |t|
      t.string :code
      t.references :quiz, null: false, foreign_key: true

      t.timestamps
    end
  end
end
