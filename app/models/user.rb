# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :boards

  validates :email, :password, presence: true
end