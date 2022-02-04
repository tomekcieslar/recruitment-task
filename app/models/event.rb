# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :tickets

  def taken_tickets_count
    tickets.select { |ticket| ["reserved", "confirmed"].include?(ticket.status) }.sum(&:quantity)
  end

  def free_tickets_count
    capacity - taken_tickets_count
  end
end
