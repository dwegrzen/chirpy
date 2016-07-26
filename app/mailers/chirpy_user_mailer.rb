class ChirpyUserMailer < ApplicationMailer
  default :from => 'admin@chirpy.com'

# send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Chirppity Chirp Chirpies' )
  end

  def send_followed_email(followee, follower)
    @user = followee
    @follower = follower
    mail( :to => @user.email,
    :subject => 'Good for you' )
  end

  def send_update_email(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Chirppity Chirp Chirpies' )
  end



end
