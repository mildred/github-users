class ReplaceFollowersByStarsToUser < ActiveRecord::Migration
  def change
    remove_column :users, :followers
    add_column :users, :stars, :integer, default: 0
  end
end
