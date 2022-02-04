class ReleaseReservedTicketsJob < ApplicationJob
  queue_as :default

  def perform
    tickets.update_all(status: "failed")
  end

  def tickets
    Ticket.where(status: "reserved").where("created_at < ?", Time.zone.now - 15.minutes)
  end
end
