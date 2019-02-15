# frozen_string_literal: true

require 'rails_helper'

RSpec.describe List, type: :model do
  it { should belong_to(:board) }

  it { should validate_presence_of(:title) }
  it { should have_db_index(:position).unique(true) }

  describe 'before_create' do
    let(:first_list) { create(:list) }

    context 'with position present' do
      it 'sets position' do
        expect(first_list.position).to eq 0
      end
      it 'sets unique position' do
        second_list = create(:list, board_id: first_list.board_id)
        expect(second_list.position).not_to eq first_list.position
      end
      it 'sets position of previons list increased by 1' do
        second_list = create(:list, board_id: first_list.board_id)
        expect(second_list.position).to eq first_list.position + 1
      end
    end

    context 'without position present' do
      it 'does not set new position' do
        create(:list, board_id: first_list.board_id)
        first_list.update(title: 'new title')
        first_list.reload
        expect(first_list.position).to eq 0
      end
    end
  end
end
