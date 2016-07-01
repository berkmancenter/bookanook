module Admin
  class NookStatisticsController < Admin::ApplicationController

    def index      
    end

    def filter
      nook_ids = params[:nooks]

      unless nook_ids.empty?
        nook_ids = nook_ids.split(',').map(&:to_i)
        incharge_locations = current_user.nooks_in_charge.ids
        nook_ids = nook_ids - (nook_ids - incharge_locations) 
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
        @reservations = @reservations.confirmed.where('"reservations"."end" < ?', end_time)
      else
        start_time = DateTime.strptime(params[:start_date], '%Y-%m-%d')
        @reservations = Reservation.happening_within(start_time..end_time, @reservations)
      end

      @reservations = @reservations.group_by { |r| r.nook_id }

      respond_to do |format|
        format.json { render json: @reservations.to_json }
      end
    end

    def resource_resolver
      @_resource_resolver ||=
        Administrate::ResourceResolver.new('admin/reservations')
    end

  end
end
