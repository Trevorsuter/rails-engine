require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should have_one(:customer).through(:invoice) }
  end
end
