class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  around_filter :set_time_zone
  rescue_from ActionController::RoutingError, :with => :render_404

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

    def render_404(exception = nil)
      if exception
          logger.info "Rendering 404: #{exception.message}"
      end

      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
end
