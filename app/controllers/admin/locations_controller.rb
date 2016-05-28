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

    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::Search.new(resource_resolver, search_term).run
      resources = resources.with_roles :admin, current_user unless current_user.superadmin?
      resources = order.apply(resources)
      resources = resources.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
      }
    end

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
      create_params.delete(:admins)
      resource = resource_class.new(create_params)

      if resource.save
        resource.amenity_list = params[:location][:amenities]
        resource.open_schedule.blocks = params[:location][:open_schedule]
        resource.open_schedule.save
        resource.save

        new_admin_ids = params[:location][:admins].split(',')

        admins_to_add = User.where(id: new_admin_ids)
        for user in admins_to_add
          user.add_role :admin, resource
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

    def update
      update_params = resource_params
      update_params.delete(:amenities)
      update_params.delete(:open_schedule)
      update_params.delete(:admins)
      if requested_resource.update(update_params)
        requested_resource.amenity_list = params[:location][:amenities]
        requested_resource.open_schedule.blocks = params[:location][:open_schedule]
        requested_resource.open_schedule.save
        requested_resource.save

        new_admin_ids = params[:location][:admins].split(',').map(&:to_i)
        old_admin_ids = User.with_role( :admin, requested_resource ).ids

        admins_to_remove = User.where(id: old_admin_ids - new_admin_ids)
        for user in admins_to_remove
          user.remove_role :admin, requested_resource
        end

        admins_to_add = User.where(id: new_admin_ids - old_admin_ids)
        for user in admins_to_add
          user.add_role :admin, requested_resource
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
  end
end
