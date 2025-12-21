class AddScoringAndAchievementsToTournaments < ActiveRecord::Migration[8.0]
  def change
    create_table :tournament_scorings do |t|
      t.references :tournament, null: false, foreign_key: true
      t.integer :position, null: false
      t.integer :points, null: false

      t.timestamps
    end

    create_table :tournament_achievements do |t|
      t.references :tournament, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.integer :points, null: false
      t.boolean :unique_completion, default: false

      t.timestamps
    end

    create_table :match_achievements do |t|
      t.references :match, null: false, foreign_key: true
      t.references :tournament_achievement, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
