# frozen_string_literal: true

module Api
  class ApplicationController < ::ApplicationController
    include ::Response
    include ::ExceptionHandler

    before_action :authorize_request
    attr_reader :current_user

    private

    def authorize_request
      @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
    end

    def broadcast_board
      BoardsChannel.broadcast_to @board, data: @data, auth_token: request.headers['Authorization'], type: @type
    end

    def broadcast_list
      ListsChannel.broadcast_to @list, data: @data, auth_token: request.headers['Authorization'], type: @type
    end
  end
end
