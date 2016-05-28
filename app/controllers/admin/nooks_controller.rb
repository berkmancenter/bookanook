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

    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::Search.new(resource_resolver, search_term).run
      unless current_user.superadmin?
        locations = Location.with_roles(:admin, current_user)
        resources = resources.where(location_id: locations.ids)
      end
      resources = order.apply(resources)
      resources = resources.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
      }
    end

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
