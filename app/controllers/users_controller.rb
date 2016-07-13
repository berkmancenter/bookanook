class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :authenticate_admin!, only: [ :index, :show ]
  before_action :authenticate_user!, only: [ :notifications ]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def notifications
    @notifications = current_user.notifications
    @title = t('titles.my_notifications')

    respond_to do |format|
      format.html { render :notifications }
    end
  end

  def new_notifications
    @notifications = current_user.notifications.unseen
    @notifications.each { |n| n.update_attribute(:seen, true) }
    @title = t('titles.new_notifications')

    respond_to do |format|
      format.html { render :notifications }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
