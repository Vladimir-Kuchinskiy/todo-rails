# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boards API', type: :request do
  let(:user) { create(:user) }
  let!(:boards) { create_list(:board, 2, user_id: user.id) }
  let(:board_id) { boards.first.id }
  let(:headers) { valid_headers }

  describe 'GET /api/boards' do
    before do
      get '/api/boards', headers: headers
    end

    it 'returns boards' do
      expect(json['data']).not_to be_empty
      expect(json['data'].size).to eq(2)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/boards/:id' do
    before { get "/api/boards/#{board_id}", headers: headers }

    context 'when the record exists' do
      it 'returns the board' do
        expect(json).not_to be_empty
        expect(json['data']['id'].to_i).to eq(board_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:board_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Board/)
      end
    end
  end

  describe 'POST /api/boards' do
    context 'when tries to create personal board' do
      let(:valid_attributes) { { title: 'Learn Elm' }.to_json }

      context 'when does not try to create more then 5th board' do
        context 'when the request is valid' do
          before do
            post '/api/boards', params: valid_attributes, headers: headers
          end

          it 'creates a board' do
            expect(json['data']['attributes']['title']).to eq('Learn Elm')
          end

          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end
        end

        context 'when the request is invalid' do
          before { post '/api/boards', headers: headers }

          it 'returns status code 422' do
            expect(response).to have_http_status(422)
          end

          it 'returns a validation failure message' do
            expect(response.body)
              .to match(/Validation failed: Title can't be blank/)
          end
        end
      end

      context 'when tries to create more than 5th board' do
        context 'when still has membership' do
          before do
            create(:subscription, user_id: user.id)
            create_list(:board, 5, user_id: user.id)
            post '/api/boards', params: valid_attributes, headers: headers
          end

          it 'creates a board' do
            expect(json['data']['attributes']['title']).to eq('Learn Elm')
          end

          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end
        end

        context 'when do not has membership' do
          it 'returns status code 403' do
            create_list(:board, 5, user_id: user.id)
            post '/api/boards', params: valid_attributes, headers: headers
            expect(response).to have_http_status(403)
          end
        end
      end
    end

    context 'when tries to create team board' do
      let(:team) { create(:user_team, user_id: user.id, team_id: create(:team).id, roles: ['creator']).team }
      let(:valid_attributes) { { title: 'Learn Elm' }.to_json }

      context 'when a creator of a team' do
        context 'when the request is valid' do
          context 'when still has membership and tries to create more than 5 boards' do
            before do
              create(:subscription, user_id: user.id)
              create_list(:board, 5, user_id: user.id, team_id: team.id)
              post "/api/teams/#{team.id}/boards", params: valid_attributes, headers: headers
            end

            it 'creates a board' do
              expect(json['data']['attributes']['title']).to eq('Learn Elm')
            end

            it 'returns status code 201' do
              expect(response).to have_http_status(201)
            end
          end

          context 'when do not has membership and tries to create more than 5 boards' do
            it 'returns status code 403' do
              create_list(:board, 5, user_id: user.id, team_id: team.id)
              post "/api/teams/#{team.id}/boards", params: valid_attributes, headers: headers
              expect(response).to have_http_status(403)
            end
          end
        end
      end

      context 'when not a creator of a team' do
        context 'when the request is valid' do
          let!(:user) { create(:user_team, team_id: team.id, user_id: create(:user).id).user }
          let(:team) do
            create(:user_team, user_id: create(:user).id, team_id: create(:team).id, roles: ['creator']).team
          end

          it 'returns status code 403' do
            post "/api/teams/#{team.id}/boards", params: valid_attributes, headers: headers
            expect(response).to have_http_status(403)
          end
        end
      end
    end
  end

  describe 'PUT /api/boards/:id' do
    context 'when tries to update personal board' do
      before do
        valid_attributes = { title: 'Shopping' }.to_json
        put "/api/boards/#{board_id}", params: valid_attributes, headers: headers
      end

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when tries to update team board' do
      let(:team) { create(:user_team, user_id: user.id, team_id: create(:team).id, roles: ['creator']).team }
      let(:team_board) { create(:board, team_id: team.id, user_id: user.id) }

      before do
        valid_attributes = { title: 'Shopping' }.to_json
        put "/api/teams/#{team.id}/boards/#{team_board.id}", params: valid_attributes, headers: headers
      end

      context 'when creator of a team' do
        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end

      context 'when not a creator of a team' do
        let!(:user) { create(:user_team, team_id: team.id, user_id: create(:user).id).user }
        let(:team) { create(:user_team, user_id: create(:user).id, team_id: create(:team).id, roles: ['creator']).team }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end
    end
  end

  describe 'DELETE /api/boards/:id' do
    context 'when tries to delete personal board' do
      before { delete "/api/boards/#{board_id}", headers: headers }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when tries to delete team board' do
      let(:team) { create(:user_team, user_id: user.id, team_id: create(:team).id, roles: ['creator']).team }
      let(:team_board) { create(:board, team_id: team.id, user_id: user.id) }

      before { delete "/api/teams/#{team.id}/boards/#{team_board.id}", headers: headers }

      context 'when a creator' do
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end

      context 'when not a creator' do
        let!(:user) { create(:user_team, team_id: team.id, user_id: create(:user).id).user }
        let(:team) { create(:user_team, user_id: create(:user).id, team_id: create(:team).id, roles: ['creator']).team }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end
    end
  end
end
