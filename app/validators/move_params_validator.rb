# frozen_string_literal: true

class MoveParamsValidator
  class InvalidMoveParamsError < StandardError
    def message
      <<-TEXT
        Invalid params:
          If card_id:
            valid params: { :destination_position, :destination_list_id }.
          If list_id:
            valid params: { :destination_position }.
          Also Destination List should belong to the same board as cards list.
      TEXT
    end
  end

  def self.validate!(params)
    raise InvalidMoveParamsError unless new(params).valid?
  end

  def valid?
    valid_params?
  end

  private

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def valid_params?
    valid_card_params? || valid_list_params?
  end

  def valid_card_params?
    params[:card_id] && params[:destination_list_id] &&
      params[:destination_position] && same_board? && valid_position_for_card?
  end

  def valid_list_params?
    params[:list_id] && params[:destination_position] && valid_position_for_list?
  end

  def same_board?
    moving_card.list.board_id == destination_list.board_id
  end

  def valid_position_for_card?
    destination_position_positive? && destination_position <= destination_list.cards.count
  end

  def valid_position_for_list?
    destination_position_positive? && destination_position <= moving_list.board.lists.count
  end

  def destination_list
    @destination_list ||= List.find(params[:destination_list_id])
  end

  def moving_card
    @moving_card ||= Card.find(params[:card_id])
  end

  def moving_list
    @moving_list ||= List.find(params[:list_id])
  end

  def destination_position_positive?
    destination_position >= 0
  end

  def destination_position
    params[:destination_position].to_i
  end
end
