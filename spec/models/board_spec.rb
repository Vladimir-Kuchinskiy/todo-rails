# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Board, type: :model do
  it { is_expected.to have_many(:lists).dependent(:destroy) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:title) }

  describe '#ordered_list_ids' do
    let(:board) { create(:board) }

    context 'when board has lists' do
      it 'returns array of lists, ordered by position' do
        lists_array = create_list(:list, 3, board_id: board.id)
        ordered_list_ids = lists_array.sort_by(&:position).map(&:id).map(&:to_s)
        expect(board.ordered_list_ids).to eq ordered_list_ids
      end
    end

    context 'when board has no lists' do
      it 'returns empty array' do
        expect(board.ordered_list_ids).to eq []
      end
    end
  end
end
