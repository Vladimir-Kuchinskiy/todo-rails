# frozen_string_literal: true

require 'rails_helper'

RSpec.describe List, type: :model do
  it { is_expected.to have_many(:cards).dependent(:destroy) }

  it { is_expected.to belong_to(:board) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to have_db_index(%i[board_id position]).unique(true) }

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

  describe 'after_destroy' do
    describe '#shift_positions' do
      let(:board) { create(:board) }

      context 'when board had only 1 list' do
        it 'simply destroys a list' do
          create(:list, board_id: board.id)
          expect { board.lists.last.destroy }.to change { board.lists.count }.by(-1)
        end
      end

      context 'when board had more than 1 list' do
        before { create_list(:list, 9, board_id: board.id) }

        context 'when list position was the biggest' do
          it 'just removes a list' do
            expect { board.lists.last.destroy }.to change { board.lists.count }.by(-1)
          end
        end

        context 'when list position was in the middle' do
          it 'removes a list' do
            expect { board.lists[4].destroy }.to change { board.lists.count }.by(-1)
          end

          it 'shifts all positions after destroyed list by -1' do
            board.lists[4].destroy
            expect(board.lists.order(:position).map(&:position)).to eq((0...board.lists.count).to_a)
          end
        end

        context 'when list position was the first' do
          it 'removes a list' do
            expect { board.lists.last.destroy }.to change { board.lists.count }.by(-1)
          end

          it 'shifts all board lists position by -1' do
            board.lists.first.destroy
            expect(board.lists.order(:position).map(&:position)).to eq((0...board.lists.count).to_a)
          end
        end
      end
    end
  end

  describe '#ordered_card_ids' do
    let(:list) { create(:list) }

    context 'when list has cards' do
      it 'returns array of cards, ordered by position' do
        cards_array = create_list(:card, 3, list_id: list.id)
        ordered_card_ids = cards_array.sort_by(&:position).map(&:id).map(&:to_s)
        expect(list.ordered_card_ids).to eq ordered_card_ids
      end
    end

    context 'when list has no cards' do
      it 'returns empty array' do
        expect(list.ordered_card_ids).to eq []
      end
    end
  end

  describe '#update_to_invalid_position' do
    it 'updates to position out of positions range' do
      board = create(:board)
      list = create(:list, board_id: board.id)
      create_list(:list, 3, board_id: board.id)
      positions_array = board.lists.map(&:position)
      list.update_to_invalid_position
      expect(positions_array).not_to include list.position
    end
  end

  describe '#update_position' do
    it 'updates position to passed to method' do
      list = create(:list)
      position = 1
      list.update_position(position)
      expect(list.position).to eq position
    end
  end

  describe '#insert_card' do
    let(:list) { create(:list) }
    let(:card) { build(:card, content: 'Unique content') }
    let(:position) { 5 }

    before do
      create_list(:card, 5, list_id: list.id)
    end

    it 'inserts a card with passed position to a list' do
      list.insert_card(card, position)
      expect(list.cards.select { |c| c.position == position }.first.content).to eq card.content
    end

    it 'increases list cards count by 1' do
      expect { list.insert_card(card, position) }.to change { list.cards.count }.by(1)
    end
  end

  describe '#resources_between_positions' do
    it 'returns an array of board lists between positions' do
      board = create(:board)
      lists = create_list(:list, 5, board_id: board.id)
      from = 1
      to = 5
      lists_pack = lists.select { |l| (from..to).cover?(l.position) }
      expect(lists.first.resources_between_positions(from, to) & lists).to eq lists_pack
    end
  end
end
