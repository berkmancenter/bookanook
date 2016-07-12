module Admin
  class ReservationsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Reservation.all.paginate(10, params[:page])
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Reservation.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information
    before_filter :authorize_instance_access, only: [ :approve, :reject ]

    def new
      resource = resource_class.new
      start_time = params[:start]
      unless start_time.nil?
        resource.start = start_time.to_datetime
        resource.end = start_time.to_datetime + 2.hours - 1.seconds
      end

      render locals: {
        page: Administrate::Page::Form.new(dashboard, resource),
      }
    end

    def create
      create_params = resource_params
      create_params.delete(:remarks)
      resource = resource_class.new(create_params)

      if resource.save
        resource.remark_list = params[:reservation][:remarks]
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
        nook_ids = Location.with_roles(:admin, current_user).collect { |location| location.nooks.ids }
        resources = resources.where(nook_id: nook_ids)
      end
      resources = order.apply(resources)
      resources = resources.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      respond_to do |format|
        format.html do
          render locals: {
            resources: resources,
            search_term: search_term,
            page: page,
          }
        end
        format.json { render json: resources }
      end
    end

    def update
      update_params = resource_params
      update_params.delete(:remarks)

      prev_status = requested_resource.status
      new_status = update_params[:status]

      if requested_resource.update(update_params)
        requested_resource.remark_list = params[:reservation][:remarks]
        requested_resource.save

        unless prev_status == new_status
          UserMailer.status_update(requested_resource.requester, requested_resource, prev_status).deliver
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

    def approve
      id = params[:id]
      @reservation = Reservation.where(id: id).first
      @updated = false
      if not @reservation.nil?
        @reservation.confirm
        @reservation.save
        @updated = true
      end
      render :js, template: 'admin/reservations/status_update'
    end

    def reject
      id = params[:id]
      @reservation = Reservation.where(id: id).first
      @updated = false
      if not @reservation.nil?
        @reservation.reject
        @reservation.save
        @updated = true
      end
      render :js, template: 'admin/reservations/status_update'
    end

  end
end
