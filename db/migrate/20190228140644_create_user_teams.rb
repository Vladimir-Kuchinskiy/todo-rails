# frozen_string_literal: true

class CreateUserTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :user_teams do |t|
      t.belongs_to :user, foreign_key: true, index: true
      t.belongs_to :team, foreign_key: true, index: true

      t.string :roles
      t.timestamps
    end
  end
end
