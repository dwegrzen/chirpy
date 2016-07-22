class User < ApplicationRecord


  before_validation :name_check
  has_many :chirps

  has_secure_password
  acts_as_followable
  acts_as_follower

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: {:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/}
  validates :api_token, presence: true, uniqueness: true

  before_validation :generate_api_token, on: :create


  def regenerate_api_token
    generate_api_token
  end

  private

  def name_check
    self.name.gsub!(/\.|-|\s/, "_")
  end



  def generate_api_token
    while api_token.blank? || User.exists?(api_token: api_token)
      self.api_token = SecureRandom.hex(10)
    end
  end



end
