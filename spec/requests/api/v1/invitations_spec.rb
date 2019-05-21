# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Invitations API', type: :request do
  let(:user) { create(:user) }
  let(:receiver) { create(:user) }
  let(:team) { create(:user_team, user_id: user.id, team: create(:team), roles: ['creator']).team }
  let(:team_id) { team.id }
  let(:headers) { valid_headers }

  describe 'GET /api/invitations' do
    let(:creator) { create(:user) }
    let(:teams) do
      create_list(:user_team, 10, user_id: creator.id, team: create(:team), roles: ['creator']).map(&:team)
    end
    let!(:invitations) do
      teams.map { |team| team.invitations.create(creator_id: creator.id, receiver_id: user.id) }
    end

    before do
      get '/api/invitations', headers: headers
    end

    it 'returns invitations' do
      expect(json['data']).not_to be_empty
      expect(json['data'].size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /api/teams/:team_id/invitations' do
    context 'when request attributes are valid' do
      let(:valid_attributes) { { receiver_email: receiver.email }.to_json }

      it 'returns status code 201' do
        post "/api/teams/#{team_id}/invitations", params: valid_attributes, headers: headers
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/api/teams/#{team_id}/invitations", headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  describe 'DELETE /api/invitations/:id' do
    let!(:invitation) { create(:invitation) }

    it 'destroys invitation' do
      expect { delete "/api/invitations/#{invitation.id}", headers: headers }.to change { Invitation.count }.by(-1)
    end

    it 'returns status code 200' do
      delete "/api/invitations/#{invitation.id}", headers: headers
      expect(response).to have_http_status(200)
    end
  end
end
