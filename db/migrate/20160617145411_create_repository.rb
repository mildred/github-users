class CreateRepository < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.datetime :last_activity_at
      t.references :user, index: true, foreign_key: true
    end
  end
end
