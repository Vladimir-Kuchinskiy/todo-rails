class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.belongs_to :user, foreign_key: true, index: true
      t.belongs_to :team, foreign_key: true, index: true

      t.timestamps
    end
  end
end
