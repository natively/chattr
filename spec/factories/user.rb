# frozen_string_literal: true

FactoryBot.define do
  sequence :unique_email do |n|
    "tester#{n}@website.com"
  end

  factory :user do
    name { 'user' }

    email { generate(:unique_email) }

    password { 'password1' }

    password_confirmation { 'password1' }
  end
end
