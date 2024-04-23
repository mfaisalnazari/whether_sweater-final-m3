require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of(:password)}
  end
  describe "generate api key" do
    it 'generates a different API key each time' do
      user1 = User.create!(email: 'test1@example.com', password: 'password', password_confirmation: 'password')
      user2 = User.create!(email: 'test2@example.com', password: 'password', password_confirmation: 'password')
      expect(user1.api_key).not_to eq(user2.api_key)
    end
  end
end