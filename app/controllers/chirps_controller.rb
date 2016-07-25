class ChirpsController < ApplicationController
  before_action :set_chirp, only: [:show, :update, :destroy]
  before_action :require_user, only: [:timeline, :create, :update, :destroy]

  # GET /chirps
  def index
    @chirps = Chirp.all

    render json: @chirps
  end

  # post /timeline
  def timeline
    followers = current_user.followees(User).pluck(:id)
    all_ids = followers << current_user.id
    @timeline = Chirp.where(user_id: all_ids).order("created_at DESC")

    render json: @timeline, status: :created
  end
  # GET /chirps/1
  def show
    render json: @chirp
  end

    # render json:  @timeline, each_serializer: TimelineSerializer, status: :created


  # POST /chirps
  def create
    @chirp = current_user.chirps.new(note_params)

    if @chirp.save
      render json: @chirp, status: :created, location: @chirp
    else
      render json: @chirp.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /chirps/1
  def update
    if @chirp.update(chirp_params)
      render json: @chirp
    else
      render json: @chirp.errors, status: :unprocessable_entity
    end
  end

  # DELETE /chirps/1
  def destroy
    @chirp.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chirp
      @chirp = Chirp.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def chirp_params
      params.require(:chirp).permit(:title, :body)
    end
end
