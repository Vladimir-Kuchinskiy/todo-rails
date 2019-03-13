# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Card, type: :model do
  it { is_expected.to belong_to(:list) }

  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to have_db_index(%i[list_id position]).unique(true) }

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

  describe 'after_destroy' do
    describe '#shift_positions' do
      let(:list) { create(:list) }

      context 'when list had only 1 card' do
        it 'simply destroys a card' do
          create(:card, list_id: list.id)
          expect { list.cards.last.destroy }.to change { list.cards.count }.by(-1)
        end
      end

      context 'when list had more than 1 card' do
        before { create_list(:card, 9, list_id: list.id) }

        context 'when card position was the biggest' do
          it 'just removes a card' do
            expect { list.cards.last.destroy }.to change { list.cards.count }.by(-1)
          end
        end

        context 'when card position was in the middle' do
          it 'removes a card' do
            expect { list.cards[4].destroy }.to change { list.cards.count }.by(-1)
          end

          it 'shifts all positions after destroyed card by -1' do
            list.cards[4].destroy
            expect(list.cards.order(:position).map(&:position)).to eq((0...list.cards.count).to_a)
          end
        end

        context 'when card position was the first' do
          it 'removes a card' do
            expect { list.cards.last.destroy }.to change { list.cards.count }.by(-1)
          end

          it 'shifts all list cards position by -1' do
            list.cards.first.destroy
            expect(list.cards.order(:position).map(&:position)).to eq((0...list.cards.count).to_a)
          end
        end
      end
    end
  end

  describe '#update_to_invalid_position' do
    it 'updates to position out of positions range' do
      list = create(:list)
      card = create(:card, list_id: list.id)
      create_list(:card, 3, list_id: list.id)
      positions_array = list.cards.map(&:position)
      card.update_to_invalid_position
      expect(positions_array).not_to include(card.position)
    end
  end

  describe '#update_position' do
    it 'updates position to passed to method' do
      card = create(:card)
      position = 1
      card.update_position(position)
      expect(card.position).to eq position
    end
  end

  describe '#resources_between_positions' do
    it 'returns an array of list cards between positions' do
      list = create(:list)
      cards = create_list(:card, 5, list_id: list.id)
      from = 1
      to = 5
      cards_pack = cards.select { |l| (from..to).cover?(l.position) }
      expect(cards.first.resources_between_positions(from, to) & cards).to eq cards_pack
    end
  end
end
