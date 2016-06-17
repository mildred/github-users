class AddFollowersToUser < ActiveRecord::Migration
  def change
    add_column :users, :followers, :integer, default: 0
  end
end
