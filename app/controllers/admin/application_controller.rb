# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
class Admin::ApplicationController < Administrate::ApplicationController
  before_filter :authenticate_admin
  before_filter :authorize_class_access, only: [ :new, :create ]
  before_filter :authorize_instance_access, only: [ :edit, :update, :show ]

  private

  def authenticate_admin
    authenticate_user!
    unless current_user.superadmin? or current_user.admin?
      flash[:alert] = t('admins.unauthorized')
      redirect_to :root
    end
  end

  def authorize_class_access
    authorize! :create, resource_class
  end

  def authorize_instance_access
    authorize! :manage, requested_resource
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = t('admins.unauthorized')
    redirect_to :back
  end

  # Override this value to specify the number of elements to display at a time
  # on index pages. Defaults to 20.
  # def records_per_page
  #   params[:per_page] || 20
  # end
end
