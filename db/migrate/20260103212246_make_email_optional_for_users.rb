class MakeEmailOptionalForUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_null :users, :email_address, true

    remove_index :users, :email_address
    add_index :users, :email_address, unique: true, where: "email_address IS NOT NULL"
  end
end
