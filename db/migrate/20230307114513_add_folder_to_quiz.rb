# frozen_string_literal: true

class AddFolderToQuiz < ActiveRecord::Migration[7.0]
  def change
    create_table :folders do |t|
      t.belongs_to :academic, null: false, foreign_key: true
      t.string :name
    end

    add_reference :quizzes, :folder, null: true, foreign_key: { on_delete: :nullify }
  end
end
