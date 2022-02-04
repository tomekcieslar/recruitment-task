# frozen_string_literal: true

FactoryBot.define do
  factory :ticket do
    event
    status { "confirmed" }
    quantity { 2 }
    price { event.ticket_price * 2 }
    token { "token" }
  end
end
