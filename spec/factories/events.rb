# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { "Festival" }
    time { "2022-02-04 10:00".to_datetime }
    capacity { 5 }
    ticket_price { 10.50 }

    trait :with_ticket do
      after(:create) do |event|
        create(:ticket, event: event)
      end
    end
  end
end
