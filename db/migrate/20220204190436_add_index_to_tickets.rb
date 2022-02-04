class AddIndexToTickets < ActiveRecord::Migration[6.0]
  def change
    add_index :tickets, :status
  end
end
