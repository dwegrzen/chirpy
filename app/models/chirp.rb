class Chirp < ApplicationRecord

  belongs_to :user, optional: true

  validates :title, presence: true, length: {maximum: 80}
  validates :body, presence: true, length: {maximum: 170}
  validates :user, presence: true


end
