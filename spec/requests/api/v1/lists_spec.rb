# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Lists API', type: :request do
  let(:user) { create(:user) }
  let(:board) { create(:board, user_id: user.id) }
  let!(:lists) { create_list(:list, 20, board_id: board.id) }
  let(:board_id) { board.id }
  let(:id) { lists.first.id }
  let(:headers) { valid_headers }

  describe 'GET /api/boards/:board_id/lists' do
    before { get "/api/boards/#{board_id}/lists", headers: headers }

    context 'when board exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all board lists' do
        expect(json['data'].size).to eq(20)
      end
    end

    context 'when board does not exist' do
      let(:board_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Board/)
      end
    end
  end

  describe 'GET /api/lists/:id' do
    before { get "/api/lists/#{id}", headers: headers }

    context 'when board list exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the list' do
        expect(json['data']['id'].to_i).to eq(id)
      end
    end

    context 'when board list does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find List/)
      end
    end
  end

  describe 'POST /api/boards/:board_id/lists' do
    context 'when request attributes are valid' do
      before do
        valid_attributes = { title: 'Visit Narnia' }.to_json
        post "/api/boards/#{board_id}/lists", params: valid_attributes, headers: headers
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/api/boards/#{board_id}/lists", headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  describe 'PUT /api/lists/:id' do
    before do
      valid_attributes = { title: 'Mozart' }.to_json
      put "/api/lists/#{id}", params: valid_attributes, headers: headers
    end

    context 'when list exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the list' do
        updated_list = List.find(id)
        expect(updated_list.title).to match(/Mozart/)
      end
    end

    context 'when the list does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find List/)
      end
    end
  end

  describe 'DELETE /api/lists/:id' do
    before { delete "/api/lists/#{id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
