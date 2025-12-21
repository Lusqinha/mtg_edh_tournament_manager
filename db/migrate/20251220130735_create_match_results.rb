class CreateMatchResults < ActiveRecord::Migration[8.0]
  def change
    create_table :match_results do |t|
      t.references :user, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true
      t.references :tournament, null: false, foreign_key: true
      t.integer :score
      t.integer :eliminations
      t.integer :commander_damage
      t.integer :final_life

      t.timestamps
    end
  end
end
