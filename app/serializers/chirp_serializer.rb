class ChirpSerializer < ActiveModel::Serializer
  attributes :body, :user_id

  belongs_to :user

end
