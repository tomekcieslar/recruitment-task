# frozen_string_literal: true

class TicketSerializer
  def initialize(ticket)
    @ticket = ticket
  end

  def serialize
    {
      status: ticket.status,
      price: formated_price,
      quantity: ticket.quantity
    }
  end

  private

  attr_reader :ticket

  def formated_price
    ActionController::Base.helpers.number_to_currency(
      ticket.price.round(2), unit: "GBP", format: "%n %u"
    )
  end
end
