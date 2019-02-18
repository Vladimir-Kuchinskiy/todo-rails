# frozen_string_literal: true

module Api
  module V1
    class CardsController < ApplicationController
      before_action :set_list, only: %i[index create]
      before_action :set_card, only: %i[show update destroy]

      # GET /api/v1/cards/:id
      def show
        json_response(CardSerializer.new(@card))
      end

      # POST /api/v1/lists/:list_id/cards
      def create
        card = @list.cards.create!(card_params)
        json_response(CardSerializer.new(card), :created)
      end

      # PUT /api/v1/cards/:id
      def update
        @card.update(card_params)
        head :no_content
      end

      # DELETE /api/v1/cards/:id
      def destroy
        @card.destroy
        head :no_content
      end

      private

      def card_params
        params.permit(:content, :description)
      end

      def set_list
        @list = List.find(params[:list_id])
      end

      def set_card
        @card = Card.find_by!(id: params[:id])
      end
    end
  end
end
