# frozen_string_literal: true

class ListsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    list = List.find(params[:list_id])
    stream_for list
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
