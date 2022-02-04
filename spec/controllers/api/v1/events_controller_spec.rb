# frozen_string_literal: true

require "rails_helper"

describe Api::V1::EventsController do
  let(:expected_response_event_json) do
    {
      "name" => "Festival",
      "time" => "04 February 2022, 10:00",
      "ticket_price" => "10.50 GBP",
      "capacity" => 5,
      "taken_tickets" => 2
    }
  end

  before do
    travel_to("2022-02-01".to_date)
  end

  describe "GET /api/v1/events" do
    subject { get :index }
    context "if any available events exists" do
      let!(:event) { create(:event, :with_ticket) }
      let!(:event_2) { create(:event, time: "2022-02-02 10:00".to_datetime) }
      let!(:past_event) { create(:event, time: "2022-01-02 8:00".to_datetime) }

      it "returns formated events", :aggregate_failures do
        subject

        expect(response.parsed_body["events"].count).to eq 2
        expect(response.parsed_body["events"].first).to eq(expected_response_event_json)
        expect(response).to have_http_status(:ok)
      end
    end

    context "if there is no available events" do
      it "returns empty array", :aggregate_failures do
        subject

        expect(response.parsed_body["events"]).to eq []
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
