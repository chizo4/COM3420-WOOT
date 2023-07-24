# frozen_string_literal: true

class AddDefaultToQuizSessions < ActiveRecord::Migration[7.0]
  def change
    change_column :quiz_sessions, :position, :integer, default: 0
  end
end
