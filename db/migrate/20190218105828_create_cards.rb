# frozen_string_literal: true

class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :content
      t.text :description
      t.integer :position
      t.belongs_to :list, foreign_key: true, index: true

      t.timestamps
    end

    add_index :cards, %i[list_id position], unique: true
  end
end
