module Admin
  class NooksController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Nook.all.paginate(10, params[:page])
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Nook.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information
    def update
      update_params = resource_params
      update_params.delete(:amenities)
      update_params.delete(:open_schedule)
      if requested_resource.update(update_params)
        requested_resource.amenity_list = params[:nook][:amenities]
        requested_resource.open_schedule.blocks = params[:nook][:open_schedule]
        requested_resource.open_schedule.save
        requested_resource.save
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
  end
end
