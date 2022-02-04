require "rails_helper"

describe Api::V1::PaymentsController do
  let!(:event) { create(:event) }
  let!(:ticket) { create(:ticket, event: event) }

  describe "POST /api/v1/payments" do
    subject { post :create, params: { ticket_id: ticket.id } }

    context "if payments goes ok" do
      it "returns success and payments details", :aggregate_failures do
        subject

        expect(response).to have_http_status(:created)
        expect(response.parsed_body["success"]).to eq true
        expect(response.parsed_body["payment"]).to eq({ "amount" => ticket.price.to_s, "currency" => "GBP" })
      end
    end

    context "if card is invalid" do
      let!(:ticket) { create(:ticket, event: event, token: "card_error") }
      it "returns card error with message", :aggregate_failures do
        subject
        expect(response.parsed_body["error"]).to eq "Your card has been declined."
        expect(response).to have_http_status(402)
      end
    end

    context "if something goes wrong with payment" do
      let!(:ticket) { create(:ticket, event: event, token: "payment_error") }
      it "returns transaction error with message", :aggregate_failures do
        subject

        expect(response.parsed_body["error"]).to eq "Something went wrong with your transaction."
        expect(response).to have_http_status(402)
      end
    end
  end
end
