# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { 'this is a post' }

    content { 'this is the content of the post' }

    user { FactoryBot.create(:user) }
  end
end
