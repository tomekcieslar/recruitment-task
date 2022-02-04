# frozen_string_literal: true

class EventSerializer
  def initialize(event)
    @event = event
  end

  def serialize
    {
      name: event.name,
      time: event.time.strftime("%d %B %Y, %H:%M"),
      ticket_price: formated_price,
      capacity: event.capacity,
      taken_tickets: taken_tickets
    }
  end

  private

  attr_reader :event

  def formated_price
    ActionController::Base.helpers.number_to_currency(
      event.ticket_price.round(2), unit: "GBP", format: "%n %u"
    )
  end

  def taken_tickets
    event.taken_tickets_count
  end
end
