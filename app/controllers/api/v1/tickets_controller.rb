# frozen_string_literal: true

class Api::V1::TicketsController < ApiController
  before_action :set_event, only: :index
  before_action :set_tickets, only: :index

  def index
    response = {
      event: EventSerializer.new(@event).serialize,
      tickets: @tickets.map { |ticket| TicketSerializer.new(ticket).serialize }
    }

    render json: response
  end

  def create
    response = ::CreateTicketForm.new(ticket_params).save

    render json: response
  end

  private


  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound => error
    not_found_error(error)
  end

  def set_tickets
    @tickets = @event.tickets
  end


  def ticket_params
    params.permit(:event_id, :quantity)
  end
end
