class CreateTicketForm
  include ActiveModel::Model

  attr_accessor :quantity, :event_id
  validates_presence_of :quantity, :event_id
  validate :ticket_quantity_condition, :enough_free_tickets, :event_cannot_be_in_past

  def save
    if event.present? && valid?
      event.tickets.create(price: price, quantity: quantity, token: token)
    else
      { error: errors.full_messages.join(". ") }
    end
  end

  protected

  def price
    quantity.to_i * event.ticket_price
  end

  def token
    SecureRandom.base64(12)
  end

  def ticket_quantity_condition
    errors.add(:quantity, "invalid quantity of tickets") unless even? || avoid_one?
  end

  def enough_free_tickets
    errors.add(:quantity, "not enough tickets left.") if event.free_tickets_count < quantity.to_i
  end

  def event_cannot_be_in_past
    errors.add(:event, "can't be in past") if event.time < Time.zone.now
  end

  def even?
    quantity.to_i.even?
  end

  def avoid_one?
    event.free_tickets_count - quantity.to_i != 1
  end

  def event
    @event ||= Event.find(event_id)
  rescue ActiveRecord::RecordNotFound
    errors.add(:event, "does not exist")

    nil
  end
end
