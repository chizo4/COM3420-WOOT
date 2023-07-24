# frozen_string_literal: true

class AddCasTicketToSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :sessions, :cas_ticket, :string, index: true
  end
end
