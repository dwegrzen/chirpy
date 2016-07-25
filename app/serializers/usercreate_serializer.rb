class UsercreateSerializer < ActiveModel::Serializer
  attributes :name, :bio, :email, :userpic, :api_token

end
