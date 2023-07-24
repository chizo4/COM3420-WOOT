# frozen_string_literal: true

class CreatePlayerSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :player_sessions do |t|
      t.string :username
      t.references :quiz_session, null: false, foreign_key: true

      t.timestamps
    end
  end
end
