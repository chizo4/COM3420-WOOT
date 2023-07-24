# frozen_string_literal: true

class AddPausedToQuizSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :quiz_sessions, :paused, :boolean
  end
end
