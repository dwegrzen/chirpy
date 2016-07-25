class ChirpSerializer < ActiveModel::Serializer
  attributes :body, :user_id, :id

  belongs_to :user

end
