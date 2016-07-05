class UserMailer < ApplicationMailer
	
  def send_password(new_user)
    @user = new_user
    mail(to: @user.email, subject: 'Welcome to Book-a-Nook!')
  end

end
