# frozen_string_literal: true

require "rails_helper"

describe Api::V1::TicketsController do
  let(:expected_response_tickets_json) do
    { "status" => "confirmed", "price" => "21.00 GBP", "quantity" => 2 }
  end
  let(:expected_response_event_json) do
    {
      "name" => "Festival",
      "time" => "04 February 2022, 10:00",
      "ticket_price" => "10.50 GBP",
      "capacity" => 5,
      "taken_tickets" => 4
    }
  end

  before do
    travel_to("2022-02-01".to_date)
  end

  describe "GET /api/v1/events/:event_id/tickets" do
    let!(:event) { create(:event) }
    let!(:event_2) { create(:event) }
    let!(:event_3) { create(:event) }
    let!(:ticket) { create(:ticket, event: event) }
    let!(:ticket_2) { create(:ticket, event: event) }
    let!(:ticket_3) { create(:ticket, event: event_2) }
    let(:event_id) { event.id }

    subject { get :index, params: { event_id: event_id } }

    context "if any tickets to passed event exists" do
      it "returns formated tickets with event info", :aggregate_failures do
        subject

        expect(response.parsed_body["event"]).to eq expected_response_event_json
        expect(response.parsed_body["tickets"].count).to eq 2
        expect(response.parsed_body["tickets"].first).to eq(expected_response_tickets_json)
        expect(response).to have_http_status(:ok)
      end
    end

    context "if there is no tickets to passed event exists" do
      let(:event_id) { event_3.id }
      it "returns empty array", :aggregate_failures do
        subject

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body["tickets"]).to eq []
      end
    end

    context "if there is no event with passed_id" do
      let(:event_id) { 134123123 }
      it "returns empty array", :aggregate_failures do
        subject

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body["error"]).to eq "Couldn't find Event with 'id'=#{event_id}"
      end
    end
  end

  describe "POST /api/v1/events/:event_id/tickets" do
    let!(:event) { create(:event) }
    let!(:quantity) { 2 }
    subject { post :create, params: { event_id: event.id, quantity: quantity } }


    context "if params are valid" do
      it "returns created ticket with reserved status", :aggregate_failures do
        expect { subject }.to change { Ticket.count }.from(0).to(1)
        expect(response.parsed_body["status"]).to eq 'reserved'
        expect(response.parsed_body["price"]).to eq (event.ticket_price * quantity).to_s
        expect(response.parsed_body["event_id"]).to eq event.id
      end
    end

    context "if params are not valid" do
      let!(:quantity) { 11 }
      it "returns error with mesage", :aggregate_failures do
        subject

        expect(response.parsed_body["error"]).to eq "Quantity not enough tickets left."
        expect { subject }.not_to change { Ticket.count }
      end
    end
  end
end
