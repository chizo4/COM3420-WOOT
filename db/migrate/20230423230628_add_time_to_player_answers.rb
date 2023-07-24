# frozen_string_literal: true

class AddTimeToPlayerAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :player_answers, :time, :float
  end
end
