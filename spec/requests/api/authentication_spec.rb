# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /api/auth/login' do
    let!(:user) { create(:user) }
    let(:headers) { valid_headers.except('Authorization') }
    let(:valid_credentials) { { email: user.email, password: user.password }.to_json }
    let(:invalid_credentials) { { email: Faker::Internet.email, password: Faker::Internet.password }.to_json }

    # set request.headers to our custon headers
    # before { allow(request).to receive(:headers).and_return(headers) }

    context 'When request is valid' do
      before { post '/api/auth/login', params: valid_credentials, headers: headers }

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'When request is invalid' do
      before { post '/api/auth/login', params: invalid_credentials, headers: headers }

      it 'returns a failure message' do
        expect(json['message']).to match(/Invalid credentials/)
      end
    end
  end
end
