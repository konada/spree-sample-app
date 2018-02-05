require 'rails_helper'

RSpec.describe Spree::CSVExporter::UsersReport do
  let!(:user) { create(:user) }

  describe '.to_csv' do
    it 'returns users in .csv' do
      expect(described_class.new.to_csv).to include 'Email,Registration date'
      expect(described_class.new.to_csv).to include user.email
    end
  end
end
