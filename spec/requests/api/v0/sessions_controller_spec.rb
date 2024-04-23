require 'rails_helper'

RSpec.describe "Api::V0::SessionsController", type: :request do
  describe 'POST #create' do
    context 'with valid credentials' do
      let!(:user) do
        User.create(email: 'test@example.com', password: 'password', password_confirmation: 'password')
      end
      let(:valid_credentials) { { email: 'test@example.com', password: 'password' } }

      it 'returns status code 200' do
        post '/api/v0/sessions', params: valid_credentials
        expect(response).to have_http_status(200)
      end

      it 'returns the user data with API key' do
        post '/api/v0/sessions', params: valid_credentials
        user_json = {data:{type:'users',id:user.id.to_s,attributes:{email:user.email,api_key: user.api_key}}}.to_json
        expect(response.body).to eq(user_json)
      end
    end

    context 'with invalid credentials' do
      let(:invalid_credentials) { { email: 'test@example.com', password: 'wrong_password' } }

      it 'returns status code 401' do
        post '/api/v0/sessions', params: invalid_credentials
        expect(response).to have_http_status(401)
      end

      it 'returns an error message' do
        post '/api/v0/sessions', params: invalid_credentials
        expect(response.body).to eq({ error: 'Invalid email or password' }.to_json)
      end
    end
  end
end
