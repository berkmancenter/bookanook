class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:edit, :update, :show, :destroy, :cancel]

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.is_public.confirmed.order(updated_at: :desc).limit(500)
  end

  def mine
    @reservations = current_user.reservations
    respond_to do |format|
      format.html { render :index }
    end
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    redirect_to :root unless @reservation.requester == current_user
  end

  def edit
    if @reservation.requester == current_user
      if @reservation.modifiable?
        render layout: false if request.xhr?
      else
        flash[:alert] = t('reservations.not_modified')
        redirect_to reservation_path(@reservation)
      end
    else
      flash[:alert] = t('users.unauthorized')
      redirect_to root_path
    end
  end

  def update
    if @reservation.requester == current_user && @reservation.modifiable?
      if @reservation.update(reservation_params)
        flash[:notice] = t('reservations.updated')
        if request.xhr?
          render text: true
        else
          redirect_to reservation_path(@reservation)
        end
      else
        render :edit, status: :unprocessable_entity, layout: false if request.xhr?
      end
    else
      if request.xhr?
        render :edit, status: :unprocessable_entity, layout: false
      else
        flash[:alert] = t('reservations.not_modified')
        redirect_to reservation_path(@reservation)
      end
    end
  end

  def cancel
    if @reservation.cancelable?
      @reservation.cancel
      if @reservation.save
        flash[:notice] = t('reservations.canceled')
      else
        flash[:alert] = t('reservations.not_canceled')
      end
    else
      flash[:alert] = t('reservations.not_canceled')
    end
    redirect_to :back
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.requester = current_user
    if params[:reservation][:nook_id]
      @nook = Nook.find(params[:reservation][:nook_id])
      @reservation.nook = @nook
    end

    time_diff = Time.parse(params[:reservation][:start]).utc - Time.now.utc

    respond_to do |format|
      if time_diff.to_i < 0
        flash[:alert] = t('reservations.reservation_in_past')
        redirect_to_nooks_with_errors(format)

      elsif time_diff < @nook.reservable_before_hours.hours.to_i
        flash[:alert] = t('reservations.reservable_before', x: @nook.reservable_before_hours)
        redirect_to_nooks_with_errors(format)

      elsif time_diff < @nook.unreservable_before_days.days.to_i
        if @reservation.save
          flash[:notice] = t('reservations.submitted')
          format.html {
            if request.xhr?
              render text: nooks_url
            else
              redirect_to nooks_path
            end
          }
          format.json { render :show, status: :created, location: @reservation }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @reservation.errors, status: :unprocessable_entity }
        end

      else
        flash[:alert] = t('reservations.unreservable_before', x: @nook.unreservable_before_days)
        redirect_to_nooks_with_errors(format)
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    if @reservation.requester == current_user
      @reservation.destroy
      respond_to do |format|
        format.html { redirect_to reservations_url, notice: 'Reservation was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:name, :start, :end, :description,
                                          :url, :stream_url, :notes)
    end

    def redirect_to_nooks_with_errors(format)
      format.html {
        if request.xhr?
          render text: nooks_url
        else
          redirect_to nooks_path
        end
      }
      format.json { render json: @reservation.errors, status: :unprocessable_entity }
    end
end
