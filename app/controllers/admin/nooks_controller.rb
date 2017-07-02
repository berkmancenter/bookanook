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
        resource.amenity_list = params[:nook][:amenities]
        if params[:copy_location_schedule]
          resource.open_schedule = resource.location.open_schedule.dup
        else
          resource.open_schedule.blocks = params[:nook][:open_schedule]
          resource.open_schedule.save
        end
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
      update_params.delete(:photos)
      if requested_resource.update(update_params)
        requested_resource.amenity_list = params[:nook][:amenities]
        requested_resource.open_schedule.blocks = params[:nook][:open_schedule]
        photos = requested_resource.photos
        photos += params[:nook][:photos]
        requested_resource.photos = photos
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

    def check_availability
      reservation_id = params[:reservation_id]
      @reservation = Reservation.where(id: reservation_id).first
      @available = nil
      unless @reservation.nil?
        @available = @reservation.nook.available_for?(@reservation.start..@reservation.end,@reservation)
      end
      render :js, template: 'admin/nooks/availability'
    end

    def remove_photo
      res = requested_resource.remove_photos(params[:photo_id]) # delete the target photo
      flash[:error] = "Failed deleting photo" if res == false
      redirect_to :back
    end
  end
end
