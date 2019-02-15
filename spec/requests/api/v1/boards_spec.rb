# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boards API', type: :request do
  let!(:boards) { create_list(:board, 10) }
  let(:board_id) { boards.first.id }

  describe 'GET /api/v1/boards' do
    before { get '/api/v1/boards' }

    it 'returns boards' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/v1/boards/:id' do
    before { get "/api/v1/boards/#{board_id}" }

    context 'when the record exists' do
      it 'returns the board' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(board_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:board_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Board/)
      end
    end
  end

  describe 'POST /api/v1/boards' do
    context 'when the request is valid' do
      before do
        valid_attributes = { title: 'Learn Elm' }
        post '/api/v1/boards', params: valid_attributes
      end

      it 'creates a board' do
        expect(json['title']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/boards' }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  describe 'PUT /api/v1/boards/:id' do
    context 'when the record exists' do
      before do
        valid_attributes = { title: 'Shopping' }
        put "/api/v1/boards/#{board_id}", params: valid_attributes
      end

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /api/v1/boards/:id' do
    before { delete "/api/v1/boards/#{board_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
