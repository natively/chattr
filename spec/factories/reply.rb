FactoryBot.define do
  factory :reply do
    content { 'This is a reply to your post.' }

    user { FactoryBot.create(:user) }

    post { FactoryBot.create(:post) }
  end
end
