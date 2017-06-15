class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  around_filter :set_time_zone

  def authenticate_admin!
    redirect_to new_user_session_path unless current_user && current_user.admin?
  end

  private

    def set_time_zone
      begin
        @old_time_zone = Time.zone
        Time.zone = browser_timezone if browser_timezone.present?
        yield
      ensure
        Time.zone = @old_time_zone
      end
    end

    def browser_timezone
      cookies["browser.timezone"]
    end
end
