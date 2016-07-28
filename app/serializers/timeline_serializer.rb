class TimelineSerializer < ActiveModel::Serializer

attributes :body, :user_id, :id, :chirptime, :username, :userpic, :userpage

  def username
    object.user.name
  end

  def userpic
    object.user.userpic
  end

  def chirptime
    object.user.created_at
  end

  def userpage
    "https://arcane-shore-86443.herokuapp.com/users/#{object.user.id}"
  end

end
