class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.references :tournament, null: false, foreign_key: true
      t.references :winner, null: true, foreign_key: { to_table: :users }
      t.datetime :played_at
      t.integer :duration
      t.integer :round

      t.timestamps
    end
  end
end
