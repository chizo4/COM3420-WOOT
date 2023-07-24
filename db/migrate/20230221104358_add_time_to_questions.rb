# frozen_string_literal: true

class AddTimeToQuestions < ActiveRecord::Migration[7.0]
  def change
    change_table :questions, bulk: true do |t|
      t.integer :time, default: 10
      t.boolean :poll, default: false
    end
  end
end
