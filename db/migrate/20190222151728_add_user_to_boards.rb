# frozen_string_literal: true

class AddUserToBoards < ActiveRecord::Migration[5.2]
  def change
    add_reference :boards, :user, foreign_key: true, index: true
  end
end
