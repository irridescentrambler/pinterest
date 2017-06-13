class PinsController < ApplicationController
  before_action :set_pin, only: [:show, :edit, :update, :destroy, :like, :dislike]
  before_action :authenticate_user!
  # GET /pins
  # GET /pins.json
  def index
    @pins = Pin.all.includes(:user).as_json(:include => {:user => {:only => [:email, :avatar]}}, methods: :liked_by?)
    respond_to do |format|
      format.json { render json: @pins, status: :ok }
    end
  end

  # GET /pins/1
  # GET /pins/1.json
  def show
    @uploader = @pin.user
    @comments = @pin.comments.reorder('created_at DESC').includes(:user).as_json(:include => {:user => {:only => [:avatar, :email]}})
    liked = current_user.voted_up_on? @pin
    respond_to do |format|
      format.json { render json: { :pin => @pin, :uploader => @uploader, :comments => @comments, :liked => liked }, status: :ok }
    end
  end

  # GET /pins/new
  def new
    @pin = Pin.new
  end

  # GET /pins/1/edit
  def edit
  end

  # POST /pins
  # POST /pins.json
  def create
    @pin = Pin.new(pin_params)
    @pin.user = current_user
    respond_to do |format|
      if @pin.save
        format.html { redirect_to @pin, notice: 'Pin was successfully created.' }
        format.json { render :show, status: :created, location: @pin }
      else
        format.html { render :new }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pins/1
  # PATCH/PUT /pins/1.json
  def update
    respond_to do |format|
      if @pin.update(pin_params)
        format.html { redirect_to @pin, notice: 'Pin was successfully updated.' }
        format.json { render :show, status: :ok, location: @pin }
      else
        format.html { render :edit }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pins/1
  # DELETE /pins/1.json
  def destroy
    @pin.destroy
    respond_to do |format|
      format.html { redirect_to pins_url, notice: 'Pin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    @pin.liked_by current_user
    @comments = @pin.comments.reorder('created_at DESC').includes(:user).as_json(:include => {:user => {:only => [:avatar, :email]}})
    respond_to do |format|
      format.json { render json: { :pin => @pin, :uploader => @pin.user, :comments => @comments }, status: :ok }
    end
  end

  def dislike
    @pin.disliked_by current_user
    @comments = @pin.comments.reorder('created_at DESC').includes(:user).as_json(:include => {:user => {:only => [:avatar, :email]}})
    respond_to do |format|
      format.json { render json: { :pin => @pin, :uploader => @pin.user, :comments => @comments }, status: :ok }
    end
  end

  private
    #def set_pin_from_slug
    #  @pin = Pin.find( $redis.get(params[:id]) )
    #end

    # Use callbacks to share common setup or constraints between actions.
    def set_pin
      @pin = Pin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pin_params
      params.fetch(:pin, {}).permit(:description, :pin_content, :board_id)
    end
end
