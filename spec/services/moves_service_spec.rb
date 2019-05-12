# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MovesService do
  describe '.call' do
    context 'when params with list_id' do
      let(:board) { create(:board) }
      let(:lists) { create_list(:list, 5, board_id: board.id) }
      let(:list) { lists[lists.count / 2 + 1] }
      let(:params) { { list_id: list.id } }

      context 'when invalid_params' do
        let(:invalid_params) { params }

        before do
          expect { described_class.call(invalid_params) }.to raise_error MoveParamsValidator::InvalidMoveParamsError
        end

        context 'when params has no destination_position' do
          it 'raises InvalidMoveParamsError error' do
          end
        end

        context 'when destination_position < 0' do
          let(:invalid_params) { params.merge(destination_position: -1) }

          it 'raises InvalidMoveParamsError error' do
          end
        end

        context 'when destination_position > last position of list in a board' do
          let(:invalid_params) { params.merge(destination_position: lists.count + 5) }

          it 'raises InvalidMoveParamsError error' do
          end
        end
      end

      context 'when valid params' do
        let(:to_position) { list.position }
        let(:valid_params) { params.merge(destination_position: to_position) }

        context 'when moving list right' do
          let(:to_position) { lists.last.position }

          it 'changes position of a list' do
            expect { described_class.call(valid_params) }.to change { list.reload.position }.to(to_position)
          end

          it 'returns list' do
            expect(described_class.call(valid_params)).to eq list
          end
        end

        context 'when moving list left' do
          let(:to_position) { lists.first.position }

          it 'changes position of a list' do
            expect { described_class.call(valid_params) }.to change { list.reload.position }.to(to_position)
          end

          it 'returns list' do
            expect(described_class.call(valid_params)).to eq list
          end
        end

        context 'when not moving' do
          it 'changes position of a list' do
            expect { described_class.call(valid_params) }.not_to change { list.reload.position }.from(list.position)
          end

          it 'returns list' do
            expect(described_class.call(valid_params)).to eq list
          end
        end
      end
    end

    context 'when params with card_id' do
      let(:list) { create(:list) }
      let(:cards) { create_list(:card, 5, list_id: list.id) }
      let(:card) { cards.first }
      let(:params) { { card_id: card.id } }

      context 'when invalid_params' do
        let(:invalid_params) { params }

        before do
          expect { described_class.call(invalid_params) }.to raise_error MoveParamsValidator::InvalidMoveParamsError
        end

        context 'when params has no destination_position' do
          let(:invalid_params) { params.merge(destination_list_id: card.list_id) }

          it 'raises InvalidMoveParamsError error' do
          end
        end

        context 'when params has no destination_list_id' do
          let(:invalid_params) { params.merge(destination_position: cards.last.position) }

          it 'raises InvalidMoveParamsError error' do
          end
        end

        context 'when params has no destination_list_id and destination_position' do
          it 'raises InvalidMoveParamsError error' do
          end
        end

        context 'when destination list does not belong to the same board as moving card' do
          let(:invalid_params) { params.merge(destination_list_id: create(:list).id, destination_position: 0) }

          it 'raises InvalidMoveParamsError error' do
          end
        end
      end

      context 'when valid params' do
        context 'when card.list_id == destination_list_id' do
          let(:to_position) { card.position }
          let(:valid_params) { params.merge(destination_list_id: list.id, destination_position: to_position) }

          context 'when move card down' do
            let(:to_position) { cards.last.position }

            it 'changes position of moving card' do
              expect { described_class.call(valid_params) }.to change { card.reload.position }.to(to_position)
            end

            it 'does not change positions sequence and order' do
              old_positions_array = card.list.cards.ordered.map(&:position)
              described_class.call(valid_params)
              new_positions_array = card.list.reload.cards.ordered.map(&:position)
              expect(new_positions_array).to eq old_positions_array
            end
          end

          context 'when move card up' do
            let(:card) { cards.last }
            let(:to_position) { cards.first.position }

            it 'changes position of moving card' do
              expect { described_class.call(valid_params) }.to change { card.reload.position }.to(to_position)
            end

            it 'does not change positions sequence and order' do
              old_positions_array = card.list.cards.ordered.map(&:position)
              described_class.call(valid_params)
              new_positions_array = card.list.reload.cards.ordered.map(&:position)
              expect(new_positions_array).to eq old_positions_array
            end
          end
        end

        context 'when card.list_id != destination_list_id' do
          let(:card) { cards[cards.count / 2 + 1] }
          let(:dest_list) { create(:list, board_id: list.board_id) }
          let(:to_position) { dest_list.cards.count }
          let(:valid_params) { params.merge(destination_list_id: dest_list.id, destination_position: to_position) }
          let(:dest_list_cards) { create_list(:card, 2, list_id: dest_list.id) }

          context 'when move card down to the bottom' do
            let(:to_position) { dest_list_cards.last.position }

            it 'changes position of moving card' do
              expect { described_class.call(valid_params) }.to change { card.reload.position }.to(to_position)
            end

            it 'does not change positions sequence and order' do
              old_positions_array = dest_list_cards.map(&:position).sort
              described_class.call(valid_params)
              new_positions_array = dest_list.reload.cards.ordered.map(&:position)
              extended_position = new_positions_array.count - 1
              expect(old_positions_array.push(extended_position)).to eq new_positions_array
            end
          end

          context 'when move card up to the beginning' do
            let(:to_position) { dest_list_cards.first.position }

            it 'changes position of moving card' do
              expect { described_class.call(valid_params) }.to change { card.reload.position }.to(to_position)
            end

            it 'does not change positions sequence and order' do
              old_positions_array = dest_list_cards.map(&:position).sort
              described_class.call(valid_params)
              new_positions_array = dest_list.reload.cards.ordered.map(&:position)
              extended_position = new_positions_array.count - 1
              expect(old_positions_array.push(extended_position)).to eq new_positions_array
            end
          end

          context 'when move card to the middle' do
            let(:to_position) { dest_list_cards.count / 2 }

            it 'changes position of moving card' do
              expect { described_class.call(valid_params) }.to change { card.reload.position }.to(to_position)
            end

            it 'does not change positions sequence and order' do
              old_positions_array = dest_list_cards.map(&:position).sort
              described_class.call(valid_params)
              new_positions_array = dest_list.reload.cards.ordered.map(&:position)
              extended_position = new_positions_array.count - 1
              expect(old_positions_array.push(extended_position)).to eq new_positions_array
            end
          end
        end
      end
    end
  end
end
