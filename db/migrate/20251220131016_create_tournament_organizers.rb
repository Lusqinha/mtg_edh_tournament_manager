class CreateTournamentOrganizers < ActiveRecord::Migration[8.0]
  def change
    create_table :tournament_organizers do |t|
      t.references :tournament, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
