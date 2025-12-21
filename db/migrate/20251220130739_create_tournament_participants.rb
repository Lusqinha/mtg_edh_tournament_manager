class CreateTournamentParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :tournament_participants do |t|
      t.references :tournament, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :score, default: 0, null: false

      t.timestamps
    end
    add_index :tournament_participants, [ :tournament_id, :user_id ], unique: true
  end
end
