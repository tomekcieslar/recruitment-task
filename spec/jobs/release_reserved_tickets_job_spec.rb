require "rails_helper"

RSpec.describe ReleaseReservedTicketsJob, type: :job do
  describe "#perform_later" do
    ActiveJob::Base.queue_adapter = :test

    let!(:event) { create(:event) }
    let!(:ticket_2) { create(:ticket, event: event, status: "reserved", created_at: "2022-02-04 10:15".to_datetime) }
    let!(:ticket_3) { create(:ticket, event: event, status: "reserved", created_at: "2022-02-04 10:16".to_datetime) }
    let!(:ticket_4) { create(:ticket, event: event, status: "reserved", created_at: "2022-02-04 10:14".to_datetime) }
    let!(:ticket_5) { create(:ticket, event: event, status: "reserved", created_at: "2022-02-04 10:01".to_datetime) }
    let!(:ticket_6) { create(:ticket, event: event, created_at: "2022-02-04 10:11") }

    before do
      travel_to("2022-02-04 10:30".to_datetime)
    end

    it "change status for not payed tickets to fail", :aggregate_failures do
      expect { ReleaseReservedTicketsJob.perform_now }.to change { Ticket.where(status: "failed").count }.from(0).to(2)
    end

    it "change status for not payed tickets to fail", :aggregate_failures do
      expect { ReleaseReservedTicketsJob.perform_later }.to enqueue_job
    end
  end
end
