class Chirp < ApplicationRecord

  belongs_to :user, optional: true

  validates :body, presence: true, length: {maximum: 170}
  validates :user, presence: true


end
