module Admin
  class NookStatisticsController < Admin::ApplicationController
    require 'csv'
    include Download
    before_filter :filter, except: :index

    def index
    end

    def fetch
      @reservations_by_nook = @reservations.group_by { |r| r.nook_id }
      @reservations_by_date = @reservations.group_by { |r| r.start.strftime("%Y-%-m-%-d") }
      @reservations_by_day = @reservations.group_by { |r| r.start.wday }

      response = { reservations_by_nook: @reservations_by_nook,
                   reservations_by_date: @reservations_by_date,
                   reservations_by_day: @reservations_by_day }

      respond_to do |format|
        format.json { render json: response.to_json }
      end
    end

    # downloading filter results in CSV form
    # TO DO: Move the static paths to config
    
    # Nook dashboard is inherited from Reservations
    def resource_resolver
      @_resource_resolver ||=
        Administrate::ResourceResolver.new('admin/reservations')
    end

    private
    def filter
      nook_ids = params[:nooks]

      unless nook_ids.empty?
        nook_ids = nook_ids.split(',').map(&:to_i)
        incharge_nooks = current_user.nooks_in_charge.ids
        nook_ids = nook_ids - (nook_ids - incharge_nooks)
        @reservations = Reservation.where(nook_id: nook_ids)
      else
        @reservations = Reservation.all
      end

      if params[:end_date].empty?
        end_time = Time.now
      else
        end_time = DateTime.strptime(params[:end_date], '%Y-%m-%d').end_of_day
      end

      if params[:start_date].empty?
        @reservations = @reservations.confirmed.where('"reservations"."end_time" < ?', end_time)
      else
        start_time = DateTime.strptime(params[:start_date], '%Y-%m-%d')
        @reservations = Reservation.happening_within(start_time..end_time, @reservations) if start_time < end_time
      end
    end


  end
end
