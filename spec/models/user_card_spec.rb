# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserCard, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:card) }

  # describe 'before_create' do
  #   let(:user) { create(:user) }

  #   context 'for personal board' do
  #     let(:personal_board) { create(:board, user_id: user.id) }
  #     let(:card)           { create(:card, list_id: create(:list, board_id: personal_board.id).id) }

  #     context 'user is not owner of a board' do
  #       it 'raises an error' do
  #         user = create(:user)
  #         expect { create(:user_card, user_id: user.id, card_id: card.id) }
  #           .to raise_error(ExceptionHandler::AssignError, /Assign user is not a team member/)
  #       end
  #     end

  #     context 'user is owner of a board' do
  #       it 'creates a record in db' do
  #         expect { create(:user_card, user_id: user.id, card_id: card.id) }.to change { UserCard.count }.by(1)
  #       end
  #     end
  #   end

  #   context 'for team board' do
  #     let(:team)       { create(:user_team, user_id: user.id, team_id: create(:team).id, roles: ['creator']).team }
  #     let(:team_board) { create(:board, user_id: user.id, team_id: team.id) }
  #     let(:card)       { create(:card, list_id: create(:list, board_id: team_board.id).id) }

  #     context 'user is not a member of a board team' do
  #       it 'raises an error' do
  #         user = create(:user)
  #         expect { create(:user_card, user_id: user.id, card_id: card.id) }
  #           .to raise_error(ExceptionHandler::AssignError, /Assign user is not a team member/)
  #       end
  #     end

  #     context 'user is a member of a board team' do
  #       it 'creates a record in db' do
  #         user = create(:user_team, user_id: create(:user).id, team_id: team.id, roles: ['member'])
  #         expect { create(:user_card, user_id: user.id, card_id: card.id) }
  #           .to change { UserCard.count }.by(1)
  #       end
  #     end
  #   end
  # end
end
