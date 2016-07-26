class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :require_user

  # GET /users
  def index
    @users = User.where.not(id: current_user.id).order("name asc")

    render json: @users, scope: current_user, scope_name: :current_user
  end

  # GET /users/1
  def show
    render json: @user
  end

  #GET /profile
  def profile
    render json: current_user
  end

  #POST /search
  def search
    chirpsearch = Chirp.where("body ilike ?","%#{params[:search]}%")
    usersearch = User.where("name ilike ? or email ilike ?", "%#{params[:search]}%", "%#{params[:search]}%")
    searchresult = usersearch + chirpsearch
    if searchresult.blank?
      render json: {result: "no search results"}, status: :created, scope: current_user, scope_name: :current_user
    else
      render json: searchresult, status: :created
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      ChirpyUserMailer.send_signup_email(@user).deliver
      render json: @user, serializer: UsercreateSerializer, status: :created, location: @user
    else
      render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    current_user.destroy
  end

  def login
    if @user = User.find_by(name: params[:name])
      if @user.authenticate(params[:password])
        render json: {api_token: @user.api_token}.to_json
      else
        render json: {error: "Password incorrect"}, status: :unprocessable_entity
      end
    else
      render json: {error: "User not found"}, status: :unprocessable_entity
    end
  end

  # POST /follow/1
  def followme
    current_user.follow!(User.find(params[:id]))
    # ChirpyUserMailer.send_followed_email(User.find(params[:id]), current_user).deliver
    @fol = current_user.followees(User)
    render json: @fol, status: :accepted
  end

  # DELETE /unfollow/1
  def unfollowme
    current_user.unfollow!(User.find(params[:id]))
    @fol = current_user.followees(User)
    render json: @fol, status: :accepted
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:name, :email, :password, :userpic, :bio)
    end
end
