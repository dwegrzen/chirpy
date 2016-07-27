class TimelineSerializer < ActiveModel::Serializer

attributes :body, :user_id, :id, :chirptime, :username, :userpic

  def username
    object.user.name
  end

  def userpic
    object.user.userpic
  end

  def chirptime
    object.user.created_at
  end

end
