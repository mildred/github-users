class ReplaceUpdateDateByCreationDateToRepository < ActiveRecord::Migration
  def change
    remove_column :repositories, :last_activity_at
    add_column :repositories, :repo_created_at, :datetime
  end
end
