class Admin::NooksController < Admin::BaseController
  before_action :set_nook, only: [:show, :edit, :update, :destroy]

  helper_method :locations, :types, :amenities, :available_now

  def index
    @nooks = Nook.all
  end

  def edit
    render layout: false if request.xhr?
  end

  def new
    @nook = Nook.new
    respond_to do |format|
      format.json
      format.html { render 'edit', layout: false if request.xhr? }
    end
  end

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

  def update
    uploaded_image = params[:nook][:image]
    if (!uploaded_image.nil?)
      @nook.photos = @nook.photos.push(uploaded_image)
      @nook.save!

      render :json => @nook.photos, status: :ok

      return
    end

    respond_to do |format|
      if @nook.update(nook_params)
        format.html { redirect_to [:admin, @nook], notice: 'Nook was successfully updated.' }
        format.json { render :show, status: :ok, location: @nook }
      else
        format.html { render :edit }
        format.json { render json: @nook.errors, status: :unprocessable_entity }
      end
    end
  end

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
