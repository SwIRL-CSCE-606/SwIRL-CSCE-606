require 'rails_helper'

RSpec.describe Event, type: :model do
    before do
        if described_class.where(name: "CSCE 606").empty?
            described_class.create( name: "CSCE 606",
                                    venue: "Zachery Complex",
                                    date: "2023-01-01",
                                    time: "10:20:00AM")
        end
    end

    describe 'edit event' do
        it 'edit event that exists' do
            event = described_class.find_by(name: "CSCE 606")
            event.update(venue: "HRBB")
            expect(event.venue).to eq "HRBB"
        end
    end

    describe 'new event' do
        it 'new event' do
            described_class.create(name: "CSCE 645")
            event = described_class.find_by(name: "CSCE 645")
            expect(event.name).to eq "CSCE 645"
        end
    end

    describe 'delete event' do
        it 'delete event' do
            event = described_class.find_by(name: "CSCE 606")
            event.destroy
            expect(described_class.find_by(name: "CSCE 606")).to eq nil
        end
    end

end
