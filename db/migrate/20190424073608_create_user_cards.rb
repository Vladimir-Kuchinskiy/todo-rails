# frozen_string_literal: true

class CreateUserCards < ActiveRecord::Migration[5.2]
  def change
    create_table :user_cards do |t|
      t.belongs_to :user, foreign_key: true, index: true
      t.belongs_to :card, foreign_key: true, index: true

      t.timestamps
    end
  end
end
