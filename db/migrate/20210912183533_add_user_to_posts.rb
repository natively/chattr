# frozen_string_literal: true

# Associate OP with the post
class AddUserToPosts < ActiveRecord::Migration[6.1]
  def change
    add_reference :posts, :user, index: true
  end
end
