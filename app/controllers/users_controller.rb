class UsersController < ApplicationController
  respond_to :json

  before_action :authenticate_user!, except: [:create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
    respond_to do |format|
      format.json { render :json => @user }
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      respond_to do |format|
        format.json { render :json => { message: "Successfully registered", :user => @user, message_type: "Success" }, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render :json => { message: @user.errors.full_messages, message_type: "Error" } }
      end
    end
  end

  def edit
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.json { render :json => @user }
    end
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(update_user_params)
        format.json { render json: @user, status: :ok }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private
    def user_params
      params.permit(:email, :password, :avatar)
    end

    def update_user_params
      params.permit(:email, :password, :avatar)
    end
end
