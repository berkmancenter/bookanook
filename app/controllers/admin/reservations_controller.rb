class Admin::ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]

  helper_method :locations, :types, :nooks, :statuses, :status_collection

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
  end

  # GET /reservations/1/edit
  def edit
    render layout: false if request.xhr?
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to admin_reservations_path, notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url, notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:start, :end, :description, :notes, :status)
    end

    def locations
      @locations ||= nooks.collect(&:location).uniq
    end

    def nooks
      @nooks ||= @reservations.collect(&:nook).uniq
    end

    def types
      @types ||= nooks.collect(&:type).uniq
    end

    def statuses
      @statuses = @reservations.collect(&:status).uniq
    end

    def status_collection
      Reservation::STATUSES.collect do |r|
        [t(r.downcase.tr(' ', '_'), scope: [:reservations, :filters, :status]), r]
      end
    end
end
