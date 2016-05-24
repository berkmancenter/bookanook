module Admin
  class LocationsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Location.all.paginate(10, params[:page])
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Location.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information

    def new
      resource = resource_class.new
      resource.open_schedule = OpenSchedule.new
      resource.open_schedule.add_9_to_5

      render locals: {
        page: Administrate::Page::Form.new(dashboard, resource),
      }
    end

    def create
      create_params = resource_params
      create_params.delete(:amenities)
      create_params.delete(:open_schedule)
      resource = resource_class.new(create_params)

      if resource.save
        resource.amenity_list = params[:location][:amenities]
        resource.open_schedule.blocks = params[:location][:open_schedule]
        resource.open_schedule.save
        resource.save
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

    def update
      update_params = resource_params
      update_params.delete(:amenities)
      update_params.delete(:open_schedule)
      if requested_resource.update(update_params)
        requested_resource.amenity_list = params[:location][:amenities]
        requested_resource.open_schedule.blocks = params[:location][:open_schedule]
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
