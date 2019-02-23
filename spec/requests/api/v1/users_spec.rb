# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user, password: user.password, password_confirmation: user.password).to_json
  end

  describe 'POST /api/signup' do
    context 'when valid request' do
      before do
        post '/api/signup', params: valid_attributes, headers: headers
      end

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { post '/api/signup', headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message for email' do
        expect(json['message']).to include("Email can't be blank")
      end

      it 'returns failure message for password' do
        expect(json['message'])
          .to include("Password can't be blank, Password is too short (minimum is 8 characters)")
      end
    end
  end
end
