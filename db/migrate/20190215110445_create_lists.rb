# frozen_string_literal: true

class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :title
      t.integer :position
      t.references :board, foreign_key: true

      t.timestamps
    end

    add_index :lists, :position, unique: true
  end
end
