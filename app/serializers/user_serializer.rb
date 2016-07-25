class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :userpic, :bio

  has_many :chirps
end
