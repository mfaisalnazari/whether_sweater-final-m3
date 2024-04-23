require 'rails_helper'

RSpec.describe "Api::V0::Users", type: :request do
  describe "POST /api/v0/users" do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      end

      it 'creates a new user' do
        expect {
          post '/api/v0/users', params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'returns status code 201' do
        post '/api/v0/users', params: valid_params
        expect(response).to have_http_status(201)
      end

      it 'returns the created user as JSON' do
        post '/api/v0/users', params: valid_params
        expect(response.body).to eq(UserSerializer.new(User.last).to_json)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'wrong_password'
        }
      end

      it 'does not create a new user' do
        expect {
          post '/api/v0/users', params: invalid_params
        }.not_to change(User, :count)
      end

      it 'returns status code 400' do
        post '/api/v0/users', params: invalid_params
        expect(response).to have_http_status(400)
      end

      it 'returns errors as JSON' do
        post '/api/v0/users', params: invalid_params
        response_body = JSON.parse(response.body)
        expected_errors = {
          "password_confirmation" => ["doesn't match Password"]
        }
        expect(response_body['errors']).to eq(expected_errors)
      end   
    end
  end
end
