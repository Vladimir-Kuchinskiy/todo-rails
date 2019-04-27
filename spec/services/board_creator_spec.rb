# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoardCreator do
  describe '.call' do
    let(:user) { create(:user) }

    context 'when creates board for user' do
      context 'when valid_params' do
        let(:valid_params) { { title: 'Team First' } }

        it 'creates new board' do
          expect { described_class.call(valid_params, user) }.to change { user.boards.personal.count }.by 1
        end
      end
    end

    context 'when creates board for team' do
      let(:team) { create(:user_team, user_id: user.id, roles: ['creator']).team }
      let(:valid_params) { { title: 'Team First', team_id: team.id } }

      context 'when a team creator' do
        context 'when valid_params' do
          it 'creates new board for user' do
            expect { described_class.call(valid_params, user) }.to change { user.boards.count }.by 1
          end

          it 'does not change personal boards count for user' do
            expect { described_class.call(valid_params, user) }.to change { user.boards.personal.count }.by 0
          end

          it 'creates new board for team' do
            expect { described_class.call(valid_params, user) }.to change { team.boards.count }.by 1
          end
        end
      end

      context 'when not a team creator' do
        context 'when valid_params' do
          let(:member) { create(:user) }

          before { create(:user_team, user_id: member.id, team_id: team.id) }

          it 'creates new board for user' do
            expect { described_class.call(valid_params, member) }
              .to raise_error(ExceptionHandler::BoardAccessDenied, %r{Sorry, you can not create/update/delete})
          end
        end
      end
    end
  end
end
