# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cards API' do
  let!(:list) { create(:list) }
  let!(:cards) { create_list(:card, 20, list_id: list.id) }
  let(:list_id) { list.id }
  let(:id) { cards.first.id }

  describe 'GET /api/v1/cards/:id' do
    before { get "/api/v1/cards/#{id}" }

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

  describe 'POST /api/v1/lists/:list_id/cards' do
    context 'when request attributes are valid' do
      before do
        valid_attributes = { content: 'Visit Narnia', description: 'A very important card' }
        post "/api/v1/lists/#{list_id}/cards", params: valid_attributes
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/api/v1/lists/#{list_id}/cards", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Content can't be blank/)
      end
    end
  end

  describe 'PUT /api/v1/cards/:id' do
    before do
      valid_attributes = { content: 'Mozart' }
      put "/api/v1/cards/#{id}", params: valid_attributes
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

  describe 'DELETE /api/v1/cards/:id' do
    before { delete "/api/v1/cards/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
