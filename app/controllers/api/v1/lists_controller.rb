# frozen_string_literal: true

module Api
  module V1
    class ListsController < ApplicationController
      before_action :set_board
      before_action :set_board_list, only: %i[show update destroy]

      # GET /boards/:board_id/lists
      def index
        json_response(@board.lists)
      end

      # GET /boards/:board_id/lists/:id
      def show
        json_response(@list)
      end

      # POST /boards/:board_id/lists
      def create
        list = @board.lists.create!(list_params)
        json_response(list, :created)
      end

      # PUT /boards/:board_id/lists/:id
      def update
        @list.update(list_params)
        head :no_content
      end

      # DELETE /boards/:board_id/lists/:id
      def destroy
        @list.destroy
        head :no_content
      end

      private

      def list_params
        params.permit(:title)
      end

      def set_board
        @board = Board.find(params[:board_id])
      end

      def set_board_list
        @list = @board.lists.find_by!(id: params[:id]) if @board
      end
    end
  end
end
