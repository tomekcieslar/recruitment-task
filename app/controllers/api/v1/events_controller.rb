# frozen_string_literal: true

class Api::V1::EventsController < ApiController
  def index
    events = Event.includes(:tickets).where("time > ?", Time.zone.now)

    render json: { events: events.map { |event| EventSerializer.new(event).serialize } }
  end
end
