# frozen_string_literal: true

class ChangeDataTypeForPosition < ActiveRecord::Migration[7.0]
  def change
    change_column(:quiz_sessions, :position, :float)
  end
end
