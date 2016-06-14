module Admin
  class WelcomeController < Admin::ApplicationController

    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::Search.new(resource_resolver, search_term).run
      resources = order.apply(resources)
      resources = resources.page(params[:page]).per(records_per_page)
      resources = current_user.reservations_in_charge(resources)

      todays_reservations = resources.where( 'start BETWEEN ? AND ?',
                                              DateTime.now.beginning_of_day,
                                              DateTime.now.end_of_day ).confirmed

      pending_reservations = resources.where(status: Reservation::Status::PENDING)

      canceled_reservations = resources.where(status: Reservation::Status::CANCELED)

      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        todays_reservations: todays_reservations,
        pending_reservations: pending_reservations,
        canceled_reservations: canceled_reservations,
        search_term: search_term,
        page: page,
      }
    end

    def resource_resolver
      @_resource_resolver ||=
        Administrate::ResourceResolver.new('admin/reservations')
    end

  end
end
