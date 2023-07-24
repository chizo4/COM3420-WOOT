# frozen_string_literal: true

class SetDefaultTrueForAnswerCorrect < ActiveRecord::Migration[7.0]
  def change
    change_column_default :answers, :correct, from: nil, to: true
  end
end
