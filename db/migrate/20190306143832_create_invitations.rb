# frozen_string_literal: true

class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.bigint :creator_id, foreign_key: true, index: true
      t.bigint :receiver_id, foreign_key: true, index: true
      t.belongs_to :team, foreign_key: true, index: true

      t.timestamps
    end
  end
end
