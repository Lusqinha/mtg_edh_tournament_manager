class CreateTournaments < ActiveRecord::Migration[8.0]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :number_of_rounds
      t.integer :max_players

      t.timestamps
    end
  end
end
