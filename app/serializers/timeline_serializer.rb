class TimelineSerializer < ActiveModel::Serializer

attributes :body, :user_id, :id, :created_at, :username, :userpic

  def username
    object.user.name
  end

  def userpic
    object.user.userpic
  end

  
end
