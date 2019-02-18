# frozen_string_literal: true

class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :title
      t.integer :position
      t.belongs_to :board, foreign_key: true, index: true

      t.timestamps
    end

    add_index :lists, %i[board_id position], unique: true
  end
end
