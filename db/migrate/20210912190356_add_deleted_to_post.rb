class AddDeletedToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :deleted, :boolean, default: false, nil: false
  end
end
