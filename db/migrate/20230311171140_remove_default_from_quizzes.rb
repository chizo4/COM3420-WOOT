# frozen_string_literal: true

class RemoveDefaultFromQuizzes < ActiveRecord::Migration[7.0]
  def change
    change_column_default :quizzes, :academic_id, nil
  end
end
