# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cards API', type: :request do
  let(:user) { create(:user) }
  let(:board) { create(:board, user_id: user.id) }
  let!(:list) { create(:list, board_id: board.id) }
  let!(:cards) { create_list(:card, 20, list_id: list.id) }
  let(:list_id) { list.id }
  let(:id) { cards.first.id }
  let(:headers) { valid_headers }

  describe 'GET /api/cards/:id' do
    before { get "/api/cards/#{id}", headers: headers }

    context 'when list -> card exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the card' do
        expect(json['data']['id'].to_i).to eq(id)
      end
    end

    context 'when list -> card does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Card/)
      end
    end
  end

  describe 'POST /api/lists/:list_id/cards' do
    context 'when request attributes are valid' do
      before do
        valid_attributes = { content: 'Visit Narnia', description: 'A very important card' }.to_json
        post "/api/lists/#{list_id}/cards", params: valid_attributes, headers: headers
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/api/lists/#{list_id}/cards", headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Content can't be blank/)
      end
    end
  end

  describe 'PUT /api/cards/:id' do
    before do
      valid_attributes = { content: 'Mozart' }.to_json
      put "/api/cards/#{id}", params: valid_attributes, headers: headers
    end

    context 'when card exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the card' do
        updated_card = Card.find(id)
        expect(updated_card.content).to match(/Mozart/)
      end
    end

    context 'when the card does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Card/)
      end
    end
  end

  describe 'DELETE /api/cards/:id' do
    before { delete "/api/cards/#{id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
