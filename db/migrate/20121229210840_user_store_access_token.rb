class UserStoreAccessToken < ActiveRecord::Migration
  def change
    add_column :users, :access_token, :string
    add_column :users, :token_expire, :integer
  end
end
