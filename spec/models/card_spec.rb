# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Card, type: :model do
  it { should belong_to(:list) }

  it { should validate_presence_of(:content) }
  it { should have_db_index(:position).unique(true) }

  describe 'before_create' do
    context '#set_position' do
      let(:first_card) { create(:card) }

      it 'sets position' do
        expect(first_card.position).to eq 0
      end

      it 'sets unique position' do
        second_card = create(:card, list_id: first_card.list_id)
        expect(second_card.position).not_to eq first_card.position
      end

      it 'sets position of previons card increased by 1' do
        second_card = create(:card, list_id: first_card.list_id)
        expect(second_card.position).to eq first_card.position + 1
      end
    end
  end
end
