# frozen_string_literal: true

class CreateSharingTable < ActiveRecord::Migration[7.0]
  def change
    create_table :sharing_table do |t|
      t.belongs_to :academic, null: false, foreign_key: true
      t.belongs_to :quiz, null: false, foreign_key: true

      t.index %i[academic_id quiz_id], unique: true

      t.timestamps
    end
  end
end
