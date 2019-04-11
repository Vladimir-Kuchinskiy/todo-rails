# frozen_string_literal: true

module Api
  module V1
    class BoardsController < ApplicationController
      before_action :set_board, only: :show
      before_action :verify_owner_and_set_board, only: %i[update destroy]

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
                        include: %i[lists lists.cards],
                        params: { current_user_id: current_user.id }
                      ))
      end

      # PUT /boards/:id
      def update
        @board.update(board_params)
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
                   BoardOwnerValidator.validate_and_return_board!(params, current_user)
                 else
                   current_user.boards.find(params[:id])
                 end
      end
    end
  end
end
