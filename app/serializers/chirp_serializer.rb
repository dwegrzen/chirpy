class ChirpSerializer < ActiveModel::Serializer
  attributes :title, :body, :user_id

  belongs_to :user

end
