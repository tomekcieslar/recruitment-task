10.times do
  e = Event.create!(
    name: Faker::FunnyName.four_word_name,
    time: Faker::Time.forward,
    capacity: 9,
    ticket_price: Faker::Number.decimal(l_digits: 2, r_digits: 2)
  )

  2.times do
    Ticket.create!(status: 'confirmed', quantity: 2, event: e, price: 2 * e.ticket_price)
  end
end
