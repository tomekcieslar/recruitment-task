class Api::V1::PaymentsController < ApiController
  BRITISH_POUNDS = "GBP"
  def create
    respond = Payment::Gateway.charge(amount: ticket.price, token: ticket.token, currency: BRITISH_POUNDS)

    ticket.update(status: "confirmed")

    render json: { success: true, payment: respond }, status: 201
  end

  private

  def ticket
    @ticket ||= Ticket.find(params[:ticket_id])
  end
end
