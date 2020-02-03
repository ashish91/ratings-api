class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.float :avg_ratings
      t.jsonb :count_ratings, null: false, default: '{}'

      t.timestamps
    end
  end
end
