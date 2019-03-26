# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.belongs_to :user, index: true, foreign_key: true
      t.timestamps
    end

    User.all.map { |user| Profile.create(user_id: user.id) }
  end
end
