class AddUuidToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :uuid, :string

    reversible do |dir|
      dir.up do
        User.find_each do |user|
          user.update_column(:uuid, SecureRandom.uuid)
        end
      end
    end

    change_column_null :users, :uuid, false
    add_index :users, :uuid, unique: true
  end
end
