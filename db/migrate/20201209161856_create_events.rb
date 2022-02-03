class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :time
      t.integer :capacity
      t.decimal :ticket_price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
