RSpec.describe CreateTicketForm do
  describe ".call" do\
    let!(:event) { create :event, capacity: 6 }
    let!(:current_time) { "2022-02-01 10:00".to_datetime }
    let(:params) { { event_id: event.id, quantity: 2 } }
    subject { described_class.new(params).save }

    before do
      travel_to current_time
    end

    context "when all passed parameters are valid" do
      it "creates reserved ticket", :aggregate_failures do
        expect { subject }.to change { Ticket.count }.from(0).to(1)
        expect(subject.status).to eq "reserved"
      end
    end

    context "when event is from past" do
      let!(:current_time) { "2022-02-28 10:00".to_datetime }

      it "return error with message" do
        expect(subject[:error]).to eq "Event can't be in past"
      end
    end

    context "when quantity is null" do
      let(:params) { { event_id: event.id, quantity: nil } }

      it "return error with message" do
        expect(subject[:error]).to eq "Quantity can't be blank"
      end
    end

    context "when event is null" do
      let(:params) { { event_id: nil, quantity: 2 } }

      it "return error with message" do
        expect(subject[:error]).to eq "Event does not exist"
      end
    end

    context "when event id does not exist" do
      let(:params) { { event_id: 12321312312, quantity: 2 } }

      it "return error with message" do
        expect(subject[:error]).to eq "Event does not exist"
      end
    end

    context "when quantity is grater than free tickets" do
      let(:params) { { event_id: event.id, quantity: 7 } }

      it "return error with message" do
        expect(subject[:error]).to eq "Quantity not enough tickets left."
      end
    end

    context "when after create odd tickets will be 1 ticket free" do
      let(:params) { { event_id: event.id, quantity: 5 } }

      it "return error with message" do
        expect(subject[:error]).to eq "Quantity invalid quantity of tickets"
      end
    end
  end
end
