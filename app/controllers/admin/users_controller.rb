module Admin
  class UsersController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = User.all.paginate(10, params[:page])
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   User.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information

    before_filter :authorize_index_access, only: :index

    def create
      create_params = resource_params
      create_params.delete(:is_superadmin)
      resource = resource_class.new(create_params)
      resource.password = resource.generate_password
      resource.password_confirmation = resource.password
      resource.skip_confirmation!

      if resource.save
        UserMailer.send_password(resource).deliver_now
        if params[:is_superadmin]
          resource.add_superadmin
        else
          resource.remove_superadmin
        end
        redirect_to(
          [namespace, resource],
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end

    def edit
      @is_superadmin = requested_resource.has_role? :superadmin
      super
    end

    def update
      update_params = resource_params
      update_params.delete(:is_superadmin)

      if requested_resource.update(update_params)
        if params[:is_superadmin]
          requested_resource.add_superadmin
        else
          requested_resource.remove_superadmin
        end
        redirect_to(
          [namespace, requested_resource],
          notice: translate_with_resource("update.success"),
        )
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, requested_resource),
        }
      end
    end

    private
    def authorize_index_access
      authorize! :read, User
    end
  end
end
