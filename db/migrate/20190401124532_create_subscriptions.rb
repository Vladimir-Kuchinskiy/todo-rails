# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.datetime :expires_at
      t.belongs_to :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
