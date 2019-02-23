# frozen_string_literal: true

module Api
  module V1
    class BoardsController < ApplicationController
      before_action :set_board, only: %i[show update destroy]

      # GET /boards
      def index
        json_response(BoardSerializer.new(current_user.boards))
      end

      # POST /boards
      def create
        @board = current_user.boards.create!(board_params)
        json_response(BoardSerializer.new(@board), :created)
      end

      # GET /boards/:id
      def show
        json_response(BoardSerializer.new(@board, include: %i[lists lists.cards]))
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
        params.permit(:title)
      end

      def set_board
        @board = current_user.boards.find(params[:id])
      end
    end
  end
end
