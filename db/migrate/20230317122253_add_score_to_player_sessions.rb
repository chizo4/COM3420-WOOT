# frozen_string_literal: true

class AddScoreToPlayerSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :player_sessions, :score, :integer
  end
end
