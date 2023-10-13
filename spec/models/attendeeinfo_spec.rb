require 'rails_helper'

RSpec.describe Attendeeinfo, type: :model do
  before do
      if described_class.where(name: "Erik").empty?
          described_class.create( name: "Erik",
                                  email: "example@gmail.com",
                                  isattending: "yes",
                                  comments: "super cool")
      end
  end

  describe 'edit attendeeinfo' do
      it 'edit attendeeinfo that exists' do
          attendee = described_class.find_by(name: "Erik")
          attendee.update(email: "example@yahoo.com")
          expect(event.email).to eq "example@yahoo.com"
      end
  end

  describe 'new attendeeinfo' do
      it 'new attendeeinfo' do
          described_class.create(name: "Karz")
          attendee = described_class.find_by(name: "Karz")
          expect(event.name).to eq "Karz"
      end
  end

  describe 'delete attendeeinfo' do
      it 'delete attendeeinfo' do
        attendee = described_class.find_by(name: "Erik")
        attendee.destroy
        expect(described_class.find_by(name: "Erik")).to eq nil
      end
  end

end