class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :require_user, only: [:timeline, :update, :destroy]
  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # Post /timeline
  def timeline
    followers = current_user.followees(User).pluck(:id)
    all_ids= followers << current_user.id
    @timeline = Chirp.where(user_id: all_ids).order("created_at DESC")

    render json: @timeline, status: :created
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, serializer: UserCreateSerializer, status: :created, location: @user
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
