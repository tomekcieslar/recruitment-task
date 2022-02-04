# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :event

  enum status: {
    reserved: "reserved",
    confirmed: "confirmed",
    failed: "failed"
  }

  scope :unavailable, -> { where(status: ["reserved", "confirmed"]) }
end
