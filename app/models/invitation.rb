# frozen_string_literal: true

class Invitation < ApplicationRecord
  belongs_to :creator, foreign_key: :creator_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User'
  belongs_to :team

  delegate :name, to: :team, prefix: true
  delegate :email, to: :creator, prefix: true
end
