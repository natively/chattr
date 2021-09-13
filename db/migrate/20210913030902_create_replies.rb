class CreateReplies < ActiveRecord::Migration[6.1]
  def change
    create_table :replies do |t|
      t.text :content, nil: false

      t.references :post, index: true

      t.references :user, index: true

      t.timestamps
    end
  end
end
