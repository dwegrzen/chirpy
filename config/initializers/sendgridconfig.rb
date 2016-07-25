ActionMailer::Base.smtp_settings = {
  :user_name => ENV['sendgrid_user'],
  :password => ENV['sendgrid_pw'],
  :domain => 'chirpy.net',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
