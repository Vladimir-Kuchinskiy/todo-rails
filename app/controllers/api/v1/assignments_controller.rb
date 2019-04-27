# frozen_string_literal: true

module Api
  module V1
    class AssignmentsController < ApplicationController
      before_action :set_card,      only: :create
      before_action :set_user,      only: :create
      before_action :set_user_card, only: :destroy
      before_action :check_rights
      after_action  :notify_assignment, only: :create
      after_action  :notify_unassignment, only: :destroy

      def create
        @user_card = @card.assign(@user)
        json_response(UserCardSerializer.new(@user_card), :created)
      end

      def destroy
        @card.unassign(@user)
        head :no_content
      end

      private

      def notify_assignment
        return unless @card.board.team_id

        UserAssignmentMailer.with(assigner: current_user, user_card: @user_card).notify_assignment.deliver_now
      end

      def notify_unassignment
        return unless @card.board.team_id

        UserAssignmentMailer.with(unassigner: current_user, user_card: @user_card).notify_unassignment.deliver_now
      end

      def set_card
        @card = Card.find_by!(id: params[:card_id])
      end

      def set_user
        @user = User.find_by!(email: params[:user_email])
      end

      def set_user_card
        @user_card = UserCard.find(params[:id])
        @user = @user_card.user
        @card = @user_card.card
      end

      def check_rights
        board = @card.list.board
        if board.team_id
          board.team.member?(current_user) && board.team.member?(@user)
        else
          board.owner?(current_user) && board.owner?(@user)
        end
      end
    end
  end
end
