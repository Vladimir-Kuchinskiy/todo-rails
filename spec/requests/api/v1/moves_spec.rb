# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Moves API', type: :request do
  describe 'POST /api/lists/:list_id/move' do
    let(:user) { create(:user) }
    let(:board) { create(:board, user_id: user.id) }
    let(:lists) { create_list(:list, 4, board_id: board.id) }
    let(:list_id) { lists.first.id }
    let(:headers) { valid_headers }

    context 'with invalid params' do
      before { post "/api/lists/#{list_id}/move", headers: headers }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns invalid params message' do
        expect(response.body).to match(/Invalid params/)
      end
    end

    context 'with valid params' do
      before do
        last_position = lists.count - 1
        valid_params = { destination_position: last_position }.to_json
        post "/api/lists/#{list_id}/move", params: valid_params, headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      context 'without existed list' do
        let(:list_id) { lists.last.id + 1 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find List/)
        end
      end
    end
  end

  describe 'POST /api/cards/:card_id/move' do
    let(:user) { create(:user) }
    let(:board) { create(:board, user_id: user.id) }
    let(:list) { create(:list) }
    let(:cards) { create_list(:card, 4, list_id: list.id) }
    let(:card_id) { cards.first.id }
    let(:headers) { valid_headers }

    context 'with invalid params' do
      before { post "/api/cards/#{card_id}/move", headers: headers }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns invalid params message' do
        expect(response.body).to match(/Invalid params/)
      end
    end

    context 'with valid params' do
      context 'when destination_list_id == card.list_id' do
        before do
          position = cards.last.position
          valid_params = { destination_position: position, destination_list_id: list.id }.to_json
          post "/api/cards/#{card_id}/move", params: valid_params, headers: headers
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        context 'without existed card' do
          let(:card_id) { cards.last.id + 1 }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find Card/)
          end
        end
      end

      context 'when destination_list_id != card.list_id' do
        let(:position) { 0 }
        let(:destination_list) { create(:list) }
        let(:valid_params) { { destination_position: position, destination_list_id: destination_list.id }.to_json }

        before { post "/api/cards/#{card_id}/move", params: valid_params, headers: headers }

        context 'with same lists board' do
          let(:destination_list) { create(:list, board_id: list.board.id) }

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end

        context 'with different lists boards' do
          it 'returns status code 400' do
            expect(response).to have_http_status(400)
          end
        end

        context 'without existed card' do
          let(:card_id) { cards.last.id + 1 }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to match(/Couldn't find Card/)
          end
        end
      end
    end
  end
end
