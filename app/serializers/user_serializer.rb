class UserSerializer < ActiveModel::Serializer
  attributes :name, :email, :userpic, :bio

  has_many :chirps
end
