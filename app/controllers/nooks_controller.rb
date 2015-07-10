class NooksController < ApplicationController
  before_action :set_nook, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, only: [:new, :edit, :update, :create, :destroy]

  # GET /nooks
  # GET /nooks.json
  def index
    @nooks = Nook.all
  end

  # GET /nooks/1
  # GET /nooks/1.json
  def show
  end

  # GET /nooks/new
  def new
    @nook = Nook.new
  end

  # GET /nooks/1/edit
  def edit
  end

  def search
    @search = NookSearch.new(params)
    @nooks = @search.results
  end

  # POST /nooks
  # POST /nooks.json
  def create
    @nook = Nook.new(nook_params)

    respond_to do |format|
      if @nook.save
        format.html { redirect_to @nook, notice: 'Nook was successfully created.' }
        format.json { render :show, status: :created, location: @nook }
      else
        format.html { render :new }
        format.json { render json: @nook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nooks/1
  # PATCH/PUT /nooks/1.json
  def update
    respond_to do |format|
      if @nook.update(nook_params)
        format.html { redirect_to @nook, notice: 'Nook was successfully updated.' }
        format.json { render :show, status: :ok, location: @nook }
      else
        format.html { render :edit }
        format.json { render json: @nook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nooks/1
  # DELETE /nooks/1.json
  def destroy
    @nook.destroy
    respond_to do |format|
      format.html { redirect_to nooks_url, notice: 'Nook was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nook
      @nook = Nook.find(params[:id])
    end

    # Change our key, value array to a real hash
    def munge_hashes(params)
      hash_param_attrs = ['attrs', 'hidden_attrs']
      hash_param_attrs.each do |attr_name|
        next unless params[attr_name]
        params[attr_name] = Hash[params[attr_name].map(&:values)]
      end
      params
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nook_params
      params.require(:nook).permit(
        :name, :location_id, :place, :type, :description,
        :bookable, :user_id, :min_schedulable, :max_schedulable,
        :min_reservation_length, :max_reservation_length, :requires_approval,
        :amenities, :min_capacity, :max_capacity, { attrs: [ :key, :value ] },
        { hidden_attrs: [ :key, :value ] }, { photos: [] }
      )
    end
end
