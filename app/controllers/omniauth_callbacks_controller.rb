class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    email = request.env['omniauth.auth']['info']['email']
    @user = User.where(email: email).first

    if @user.nil?
      @user = GoogleUser.find_or_create(request.env['omniauth.auth'])
      if @user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, event: :authentication
      else
        session['devise.google_data'] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    elsif not @user.type.nil? and @user.type == 'GoogleUser'
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:alert] = I18n.t 'users.authentication.simple_registration'
      redirect_to new_user_registration_url
    end
  end

end
