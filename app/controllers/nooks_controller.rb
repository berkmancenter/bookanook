class NooksController < ApplicationController
  before_action :set_nook, only: [:show, :reserve]
  before_action :authenticate_user!, only: [:reserve]

  helper_method :locations, :types, :amenities, :available_now

  layout false, only: [:edit]

  # GET /nooks
  # GET /nooks.json
  def index
    @nooks = []#Nook.order(:id)
  end

  # GET /nooks/1
  # GET /nooks/1.json
  def show
    respond_to do |format|
      format.json
      format.html { render @nook, layout: false if request.xhr? }
    end
  end

  def search
    @search = NookSearch.new(params)
    @nooks = @search.results.sort_by(&:id)

    respond_to do |format|
      format.json
      format.html { render 'search', layout: false if request.xhr? }
    end
  end

  def reserve
    @reservation = Reservation.new
    @reservation.nook = @nook
    respond_to do |format|
      format.json
      format.html {
        render partial: 'nooks/nook', locals: { nook: @nook }, layout: false if request.xhr?
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nook
      @nook = Nook.find(params[:id])
    end

    def locations
      @locations ||= Location.all
    end

    def types
      @types ||= @nooks.collect(&:type).uniq
    end

    def amenities
      @amenities ||= (@nooks || @nook.location.try(:nooks) || Nook.all).collect(&:amenities).flatten.uniq
    end
end
