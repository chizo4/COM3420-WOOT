# frozen_string_literal: true

class CreatePlayerAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :player_answers do |t|
      t.references :player_session, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
