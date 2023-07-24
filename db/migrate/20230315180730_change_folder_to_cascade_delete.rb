# frozen_string_literal: true

class ChangeFolderToCascadeDelete < ActiveRecord::Migration[7.0]
  def change
    remove_reference :quizzes, :folder, null: true, foreign_key: { on_delete: :nullify }
    add_reference :quizzes, :folder, null: true, foreign_key: true
  end
end
