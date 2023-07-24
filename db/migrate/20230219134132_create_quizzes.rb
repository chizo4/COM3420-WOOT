# frozen_string_literal: true

class CreateQuizzes < ActiveRecord::Migration[7.0]
  def change
    create_table :quizzes do |t|
      t.string :name

      t.timestamps
    end
  end
end
