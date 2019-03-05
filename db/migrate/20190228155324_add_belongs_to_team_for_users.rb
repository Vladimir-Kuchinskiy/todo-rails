# frozen_string_literal: true

class AddBelongsToTeamForUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :boards, :team, index: true
  end
end
