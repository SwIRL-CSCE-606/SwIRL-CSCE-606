require 'rails_helper'

# Assuming you're including helper modules in RSpec configuration.
RSpec.describe EventsHelper, type: :helper do
  describe '#readable_status' do
    it 'returns correct readable status for awaiting_reply' do
      expect(helper.readable_status('awaiting_reply')).to eq('Invitation sent - awaiting reply')
    end

    it 'returns correct readable status for replied_attending' do
      expect(helper.readable_status('replied_attending')).to eq('Replied - attending')
    end

    it 'returns correct readable status for replied_not_attending' do
      expect(helper.readable_status('replied_not_attending')).to eq('Replied - not attending')
    end

    it 'returns "Unknown Status" for any unknown status' do
      expect(helper.readable_status('invalid_status')).to eq('Unknown Status')
    end
  end

  describe '#status_class' do
    it 'returns the correct CSS class for awaiting_reply' do
      expect(helper.status_class('awaiting_reply')).to eq('status-awaiting-reply')
    end

    it 'returns the correct CSS class for replied_attending' do
      expect(helper.status_class('replied_attending')).to eq('status-attending')
    end

    it 'returns the correct CSS class for replied_not_attending' do
      expect(helper.status_class('replied_not_attending')).to eq('status-not-attending')
    end

    it 'returns "status-unknown" for any unknown status' do
      expect(helper.status_class('anything_else')).to eq('status-unknown')
    end
  end
end
