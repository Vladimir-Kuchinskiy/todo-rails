# frozen_string_literal: true

class BoardsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    board = Board.find(params[:board_id])
    stream_for board
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
