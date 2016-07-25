class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :userpic, :bio, :followees_count, :followers_count, :chirp_count, :currently_being_followed

  has_many :chirps

  def currently_being_followed
    current_user.follows?(object)
  end
  
end
