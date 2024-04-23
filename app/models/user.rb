class User < ApplicationRecord
  before_create :generate_api_key
  
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password
  has_secure_password
  
  
  
  
  private

  def generate_api_key
    self.api_key = SecureRandom.hex(16)
  end
end
