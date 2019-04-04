# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Teams API', type: :request do
  let(:user) { create(:user) }
  let(:teams) { create_list(:team, 3) }
  let(:team_id) { teams.first.id }
  let(:headers) { valid_headers }

  before { teams.each { |t| create(:user_team, user_id: user.id, team_id: t.id, roles: ['creator']) } }

  describe 'GET /api/teams' do
    before do
      get '/api/teams', headers: headers
    end

    it 'returns user teams' do
      expect(json['data']).not_to be_empty
      expect(json['data'].size).to eq(3)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/teams/:id' do
    before { get "/api/teams/#{team_id}", headers: headers }

    context 'when the record exists' do
      it 'returns the board' do
        expect(json).not_to be_empty
        expect(json['data']['id'].to_i).to eq(team_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:team_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Team/)
      end
    end
  end

  describe 'POST /api/teams' do
    let(:valid_attributes) { { name: 'The best team one' }.to_json }
    context 'when has membership' do
      before { create(:subscription, user_id: user.id) }

      context 'when the request is valid' do
        before { post '/api/teams', params: valid_attributes, headers: headers }

        it 'creates a team' do
          expect(json['data']['attributes']['name']).to eq('The best team one')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when the request is invalid' do
        before { post '/api/teams', headers: headers }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Validation failed: Name can't be blank/)
        end
      end
    end

    context 'when has no membership' do
      context 'when the request is valid' do
        before { post '/api/teams', params: valid_attributes, headers: headers }

        it 'returns status code 201' do
          expect(response).to have_http_status(403)
        end
      end
    end
  end

  describe 'PUT /api/teams/:id' do
    context 'when the record exists' do
      before do
        valid_attributes = { name: 'Shopping' }.to_json
        put "/api/teams/#{team_id}", params: valid_attributes, headers: headers
      end

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /api/teams/:id' do
    before { delete "/api/teams/#{team_id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
