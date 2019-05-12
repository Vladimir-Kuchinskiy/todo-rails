# frozen_string_literal: true

module Api
  module V1
    class BoardsController < ApplicationController
      before_action :set_board, only: :show
      before_action :verify_owner_and_set_board, only: %i[update destroy]
      after_action  :broadcast_board, only: :update

      # GET /boards
      def index
        json_response(BoardSerializer.new(current_user.boards.personal.includes(:lists)))
      end

      # POST /boards
      def create
        @board = BoardCreator.call(board_params, current_user)
        json_response(BoardSerializer.new(@board), :created)
      end

      # GET /boards/:id
      def show
        json_response(BoardSerializer.new(
                        @board,
                        include: %i[lists lists.cards lists.cards.user_cards],
                        params: { current_user_id: current_user.id, host_with_port: request.host_with_port }
                      ))
      end

      # PUT /boards/:id
      def update
        @board.update(board_params)
        @data = BoardSerializer.new(@board)
        @type = :update_board
        head :no_content
      end

      # DELETE /boards/:id
      def destroy
        @board.destroy
        head :no_content
      end

      private

      def board_params
        params.permit(:title, :team_id)
      end

      def set_board
        @board = if params[:team_id]
                   Team.find_by!(id: params[:team_id]).boards.find(params[:id])
                 else
                   current_user.boards.find(params[:id])
                 end
      end

      def verify_owner_and_set_board
        @board = if params[:team_id]
                   verify_for_team
                 else
                   current_user.boards.find(params[:id])
                 end
      end

      def verify_for_team
        team = Team.find_by!(id: params[:team_id])
        boards = team.boards.find_by!(id: params[:id])
        BoardOwnerValidator.validate_and_return_board!(team, boards, current_user)
      end
    end
  end
end
