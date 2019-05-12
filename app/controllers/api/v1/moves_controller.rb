# frozen_string_literal: true

module Api
  module V1
    class MovesController < ApplicationController
      after_action :broadcast

      def create
        @list = MovesService.call(move_params)
        @data = move_ws_data
        head :ok
      end

      private

      def broadcast
        if params[:list_id]
          @type = :move_list
          @board = @list.board
          broadcast_board
        else
          @type = :move_card
          broadcast_list
        end
      end

      def move_params
        params.permit(:card_id, :list_id, :destination_position, :destination_list_id)
      end

      def move_ws_data
        {
          source_position: params[:source_position],
          destination_position: params[:destination_position],
          source_list_id: params[:source_list_id],
          destination_list_id: params[:destination_list_id],
          draggable_id: params[:list_id] || params[:card_id]
        }
      end
    end
  end
end
