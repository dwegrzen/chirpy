class TimelineSerializer < ActiveModel::Serializer
# was used to help with timeline data format, can be used elsewhere

  attributes :body, :user_id

  belongs_to :user

end
