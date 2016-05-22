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
    render layout: false if request.xhr? 
    if @reservation.status=="Confirmed"
      flash[:notice] = "This reservation has already been confirmed"
      redirect_to reservation_path(@reservation) 
    end
  end

  def update
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
  end

  def cancel
    @reservation.cancel
    if @reservation.save
      flash[:notice] = t('reservations.canceled')
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

    respond_to do |format|
      if @reservation.save
        format.html {
          flash[:notice] = t('reservations.submitted')
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
end
