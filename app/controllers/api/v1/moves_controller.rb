# frozen_string_literal: true

module Api
  module V1
    class MovesController < ApplicationController
      def create
        MovesService.call(move_params)
        head :ok
      end

      private

      def move_params
        params.permit(:card_id, :list_id, :destination_position, :destination_list_id)
      end
    end
  end
end
