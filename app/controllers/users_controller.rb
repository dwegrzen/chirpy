class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :require_user, only: [:profile, :unfollowme, :followme, :timeline, :update, :destroy]
  # GET /users
  def index
    @users = User.all

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

  #GET /search
  def search
    chirpsearch = Chirp.where("body ilike ?","%#{params[:search]}%")
    usersearch = User.where("name ilike ? or email ilike ?", "%#{params[:search]}%", "%#{params[:search]}%")
    searchresult = usersearch + chirpsearch
    if searchresult.blank?
      render json: {result: "no search results"}, status: :created
    else
      render json: searchresult, status: :created
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      ChirpyUserMailer.end_signup_email(@user).deliver
      render json: @user, serializer: UsercreateSerializer, status: :created, location: @user
    else
      render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if current_user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
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
        render json: {errors: [{error: "Password incorrect"}]}, status: :unprocessable_entity
      end
    else
      render json: {errors: [{error: "User not found"}]}, status: :unprocessable_entity
    end
  end

  # POST /follow
  def followme
    current_user.follow!(User.find(params[:id]))
    @fol = current_user.followees(User)
    render json: @fol, status: :accepted
  end

  # DELETE /unfollow
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
