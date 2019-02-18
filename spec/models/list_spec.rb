# frozen_string_literal: true

require 'rails_helper'

RSpec.describe List, type: :model do
  it { should have_many(:cards).dependent(:destroy) }

  it { should belong_to(:board) }

  it { should validate_presence_of(:title) }
  it { should have_db_index(:position).unique(true) }

  describe 'before_create' do
    context '#set_position' do
      let(:first_list) { create(:list) }

      it 'sets position' do
        expect(first_list.position).to eq 0
      end

      it 'sets unique position' do
        second_list = create(:list, board_id: first_list.board_id)
        expect(second_list.position).not_to eq first_list.position
      end

      it 'sets position of previons list increased by 1' do
        second_list = create(:list, board_id: first_list.board_id)
        expect(second_list.position).to eq first_list.position + 1
      end
    end
  end

  describe '#ordered_card_ids' do
    let(:list) { create(:list) }

    context 'when list has cards' do
      it 'returns array of cards, ordered by position' do
        cards_array = create_list(:card, 3, list_id: list.id)
        ordered_card_ids = cards_array.sort_by(&:position).map(&:id)
        expect(list.ordered_card_ids).to eq ordered_card_ids
      end
    end

    context 'when list has no cards' do
      it 'returns empty array' do
        expect(list.ordered_card_ids).to eq []
      end
    end
  end
end
