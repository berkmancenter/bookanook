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

  end
end
