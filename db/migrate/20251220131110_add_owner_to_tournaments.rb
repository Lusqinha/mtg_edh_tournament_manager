class AddOwnerToTournaments < ActiveRecord::Migration[8.0]
  def change
    add_reference :tournaments, :owner, null: false, foreign_key: { to_table: :users }
  end
end
