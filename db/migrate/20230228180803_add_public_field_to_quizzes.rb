# frozen_string_literal: true

class AddPublicFieldToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :public, :boolean, default: false
  end
end
