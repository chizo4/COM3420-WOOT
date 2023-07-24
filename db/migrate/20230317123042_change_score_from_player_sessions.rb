# frozen_string_literal: true

class ChangeScoreFromPlayerSessions < ActiveRecord::Migration[7.0]
  def change
    change_column :player_sessions, :score, :integer, default: 0
  end
end
