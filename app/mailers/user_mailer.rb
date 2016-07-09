class UserMailer < ApplicationMailer

  def send_password(new_user)
    @user = new_user
    mail(to: @user.email, subject: t('mailers.user_mailer.send_password.subject'))
  end

  def status_update(user, reservation, prev_status)
    @user = user
    @reservation = reservation
    @location = "#{@reservation.nook.name}, #{@reservation.nook.location.name}"
    @prev_status = prev_status
    mail(to: @user.email, subject: t('mailers.user_mailer.status_update.subject'))
  end

end
