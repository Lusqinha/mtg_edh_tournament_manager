class AddMissingColumnsToMatchesAndResults < ActiveRecord::Migration[8.0]
  def change
    add_column :matches, :created_by_id, :integer
    add_foreign_key :matches, :users, column: :created_by_id
    add_index :matches, :created_by_id

    add_column :match_results, :position, :integer
  end
end
