# frozen_string_literal: true

module Api
  module V1
    class BoardsController < ::ApplicationController
      def index
        render json: []
      end
    end
  end
end
