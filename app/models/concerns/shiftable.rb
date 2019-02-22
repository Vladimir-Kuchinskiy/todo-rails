# frozen_string_literal: true

module Shiftable
  extend ActiveSupport::Concern

  def self.included(base)
    base.extend ClassMethods
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
end
