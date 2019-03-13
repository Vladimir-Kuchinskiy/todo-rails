# frozen_string_literal: true

module Movable
  extend ActiveSupport::Concern
  class TemplateError < RuntimeError; end

  def self.included(base)
    base.extend ClassMethods
    base.send(:include, InstanceMethods)
    base.class_eval do
      scope :between_positions, ->(from, to) { where(position: (from..to)) }
    end
  end

  module ClassMethods
    def shift_positions_up
      all.ordered.map { |resource| resource.update(position: resource.position - 1) }
    end

    def shift_positions_down
      all.ordered.reverse.map { |resource| resource.update(position: resource.position + 1) }
    end
  end

  module InstanceMethods
    def update_to_invalid_position
      update(position: entities.count + 10)
    end

    def update_position(position)
      update(position: position)
    end

    def resources_between_positions(from, to)
      entities.between_positions(from, to)
    end

    def insert_card(card, position)
      raise TemplateError, 'Shiftable::InstanceMethods#insert_card only for List model' if self.class.name != 'List'

      old_list = card.list
      old_position = card.position
      switch_position(card, position)
      old_list&.shift_cards_positions(old_position)
    end

    def shift_cards_positions(position)
      raise TemplateError, 'Shiftable::InstanceMethods#shift_cards_positions only for List model' if self.class.name !=
                                                                                                     'List'
      return unless cards.any?

      cards_list = cards.ordered
      return if cards_list.last.position < position

      shift_cards(cards_list, position)
    end

    private

    def switch_position(card, position)
      raise TemplateError, 'Shiftable::InstanceMethods#switch_position only for List model' if self.class.name != 'List'

      card.list_id = id
      card.position = position
      cards.bigger_than_position(position).ordered.reverse.map { |c| c.update(position: c.position + 1) }
      card.save
    end

    def shift_cards(cards, position)
      raise TemplateError, 'Shiftable::InstanceMethods#shift_cards only for List model' if self.class.name != 'List'

      transaction do
        cards.map do |card|
          if card.position > position
            card.position -= 1
            card.save
          end
        end
      end
    end

    def shift_entities(entities)
      transaction do
        entities.map do |entity|
          if entity.position > position
            entity.position -= 1
            entity.save
          end
        end
      end
    end

    def shift_positions
      return unless entities.any?

      items = entities.ordered
      return if items.empty? || items.last.position < position

      shift_entities(items)
    end

    def entities
      raise TemplateError, 'The Shiftable module requires the ' \
                           "#{self.class.name} class to define a " \
                           'entities instance method'
    end
  end
end
