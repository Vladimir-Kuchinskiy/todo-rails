# frozen_string_literal: true

module Api
  module V1
    class ListsController < ApplicationController
      before_action :set_board, only: %i[index create]
      before_action :set_list, only: %i[show update destroy]

      # GET /api/v1/boards/:board_id/lists
      def index
        json_response(ListSerializer.new(@board.lists))
      end

      # GET /api/v1/lists/:id
      def show
        json_response(ListSerializer.new(@list))
      end

      # POST /api/v1/boards/:board_id/lists
      def create
        list = @board.lists.create!(list_params)
        json_response(ListSerializer.new(list), :created)
      end

      # PUT /api/v1/lists/:id
      def update
        @list.update(list_params)
        head :no_content
      end

      # DELETE /api/v1/lists/:id
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

      def set_list
        @list = List.find_by!(id: params[:id])
      end
    end
  end
end
