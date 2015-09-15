class AddLocationAndDescriptionToUser < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :description, :string
  end
end
