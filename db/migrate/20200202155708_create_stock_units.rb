class CreateStockUnits < ActiveRecord::Migration[6.0]
  def change
    create_table :stock_units do |t|
      t.references :product, foreign_key: true
      t.integer :age, default: 0

      t.timestamps
    end
  end
end
