# frozen_string_literal: true

class Event < ApplicationRecord
  validates_presence_of :name, :time, :capacity
  validate :capacity_gater_than_zero

  has_many :tickets

  def capacity_gater_than_zero
    errors.add(:capacity, "must be grater then 0") if capacity < 1
  end

  def taken_tickets_count
    tickets.select { |ticket| ["reserved", "confirmed"].include?(ticket.status) }.sum(&:quantity)
  end

  def free_tickets_count
    capacity - taken_tickets_count
  end
end
