# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profiles API', type: :request do
  let(:user) { create(:user) }

  describe 'GET /api/profile' do
    let(:headers) { valid_headers }
    before { get '/api/profile', headers: headers }

    context 'when user is signed in' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns profile' do
        expect(json['data']).to_not be_empty
      end
    end

    context 'when user is not signed in' do
      let(:headers) { invalid_headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'GET /api/profile' do
    let(:headers) { valid_headers }
    before { get '/api/profile', headers: headers }

    context 'when user is signed in' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns profile' do
        expect(json['data']).to_not be_empty
      end
    end

    context 'when user is not signed in' do
      let(:headers) { invalid_headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
end
