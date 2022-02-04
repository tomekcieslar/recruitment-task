class AddTokenToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :token, :string
  end
end
