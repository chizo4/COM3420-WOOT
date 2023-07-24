# frozen_string_literal: true

class AddIndexToQuizSessions < ActiveRecord::Migration[7.0]
  def change
    add_index :quiz_sessions, :code, unique: true
  end
end
