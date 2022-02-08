# frozen_string_literal: true

RSpec.describe Event, type: :model do
  let!(:event) { create :event, :with_ticket }

  describe "taken_tickets_count" do
    it "returns number of reserved or confirmed tickets" do
      expect(event.taken_tickets_count).to eq 2
    end
  end

  describe "free_tickets_count" do
    it "returns capacity - taken tickets" do
      expect(event.free_tickets_count).to eq 3
    end
  end
end
