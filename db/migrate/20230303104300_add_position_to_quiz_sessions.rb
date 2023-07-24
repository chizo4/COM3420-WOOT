# frozen_string_literal: true

class AddPositionToQuizSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :quiz_sessions, :position, :integer
  end
end
