class AddInviteCodeToTournaments < ActiveRecord::Migration[8.0]
  def change
    add_column :tournaments, :invite_code, :string
    add_index :tournaments, :invite_code, unique: true
  end
end
