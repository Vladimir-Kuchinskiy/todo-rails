# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Assignments API', type: :request do
  let(:user)        { create(:user) }
  let(:assign_user) { create(:user) }
  let(:card)        { create(:card) }
  let(:req_params)  { { user_email: assign_user.email, card_id: card.id }.to_json }
  let(:headers)     { valid_headers }

  describe 'POST /api/assigments' do
    context 'for personal board' do
      let(:personal_board) { create(:board, user_id: user.id) }
      let(:card)           { create(:card, list_id: create(:list, board_id: personal_board.id).id) }

      context 'when assign user is not an owner of a board' do
        before do
          post "/api/boards/#{personal_board.id}/assignments", params: req_params, headers: headers
        end

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end

        it 'returns a failure message' do
          expect(response.body)
            .to match(/Sorry, you can not/)
        end
      end

      context 'when assign user is an owner of a board' do
        let(:assign_user) { user }

        before { post "/api/boards/#{personal_board.id}/assignments", params: req_params, headers: headers }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end
    end

    context 'for team board' do
      let(:team)       { create(:user_team, user_id: user.id, team_id: create(:team).id, roles: ['creator']).team }
      let(:team_board) { create(:board, user_id: user.id, team_id: team.id) }
      let(:card)       { create(:card, list_id: create(:list, board_id: team_board.id).id) }

      context 'when assign user is not a member of a board team' do
        before do
          post "/api/boards/#{team_board.id}/assignments", params: req_params, headers: headers
        end

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end

        it 'returns a failure message' do
          expect(response.body)
            .to match(/Assign user is not a team member/)
        end
      end

      context 'when assign user is a member of a board team' do
        let(:assign_user) { create(:user_team, user_id: create(:user).id, team_id: team.id, roles: ['member']).user }

        before { post "/api/boards/#{team_board.id}/assignments", params: req_params, headers: headers }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end
    end
  end

  describe 'DELETE /api/assigments/:id' do
    context 'for personal board' do
      let(:personal_board) { create(:board, user_id: user.id) }
      let(:card)           { create(:card, list_id: create(:list, board_id: personal_board.id).id) }
      let(:user_card)      { create(:user_card, user_id: assign_user.id, card_id: card.id) }

      before { delete "/api/assignments/#{user_card.id}", headers: headers }

      context 'when current_user is not an owner of a board' do
        let(:user)        { create(:user) }
        let(:assign_user) { create(:user) }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end

      context 'when current_user is an owner of a board' do
        let(:assign_user) { user }

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end

    context 'for team board' do
      let(:team)        { create(:user_team, user_id: user.id, team_id: create(:team).id, roles: ['creator']).team }
      let(:assign_user) { create(:user_team, user_id: create(:user).id, team_id: team.id, roles: ['member']).user }
      let(:team_board)  { create(:board, user_id: user.id, team_id: team.id) }
      let(:card)        { create(:card, list_id: create(:list, board_id: team_board.id).id) }
      let(:user_card)   { create(:user_card, user_id: assign_user.id, card_id: card.id) }

      before { delete "/api/assignments/#{user_card.id}", headers: headers }

      context 'when current_user is not an member of a team' do
        let(:user)        { create(:user) }
        let(:assign_user) { create(:user) }

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end

      context 'when current_user is an member of a board' do
        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end
  end
end
