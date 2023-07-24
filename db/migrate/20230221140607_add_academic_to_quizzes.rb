# frozen_string_literal: true

class AddAcademicToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_reference :quizzes, :academic, null: false, default: -1, foreign_key: true
  end
end
