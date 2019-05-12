# frozen_string_literal: true

class MovesService
  def initialize(params)
    @params = params
  end

  def call
    move_resource
    params[:list_id] ? resource : resource.list
  end

  def self.call(params)
    MoveParamsValidator.validate!(params)
    new(params).call
  end

  private

  attr_reader :params

  def move_resource
    send(:"move_#{type}")
  end

  def move_list
    move_resource_in_container
  end

  def move_card
    if resource.list_id == destination_list_id
      move_card_in_list
    else
      move_card_between_lists
    end
  end

  def move_card_in_list
    move_resource_in_container
  end

  def move_card_between_lists
    resource.transaction do
      destination_list = List.find(destination_list_id)
      destination_list.insert_card(resource, to_position)
    end
  end

  def move_resource_in_container
    return if resource.position == to_position

    resource.position < to_position ? move_resource_down : move_resource_up
  end

  def move_resource_down
    resources = resource.resources_between_positions(resource.position + 1, to_position)
    resource.transaction do
      resource.update_to_invalid_position
      resources.shift_positions_up
      resource.update_position(to_position)
    end
  end

  def move_resource_up
    resources = resource.resources_between_positions(to_position, resource.position - 1)
    resource.transaction do
      resource.update_to_invalid_position
      resources.shift_positions_down
      resource.update_position(to_position)
    end
  end

  def resource
    return @resourse if @resourse

    resource_class = type.capitalize.constantize
    @resourse = resource_class.find(resource_id)
  end

  def type
    @type ||= params[:list_id] ? 'list' : 'card'
  end

  def resource_id
    @resource_id ||= params[:list_id] || params[:card_id]
  end

  def to_position
    params[:destination_position].to_i
  end

  def destination_list_id
    params[:destination_list_id].to_i
  end
end
