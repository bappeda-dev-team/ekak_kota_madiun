class IndikatorsUsersController < ApplicationController
  before_action :set_indikators_user, only: %i[show edit update destroy]
  layout false, only: %i[new edit]

  # GET /indikators_users or /indikators_users.json
  def index
    @indikators_users = IndikatorsUser.all
  end

  # GET /indikators_users/1 or /indikators_users/1.json
  def show; end

  # GET /indikators_users/new
  def new
    @indikators_user = IndikatorsUser.new
  end

  # GET /indikators_users/1/edit
  def edit; end

  # POST /indikators_users or /indikators_users.json
  def create
    @indikators_user = IndikatorsUser.new(indikators_user_params)

    respond_to do |format|
      if @indikators_user.save
        format.html do
          redirect_to indikators_user_url(@indikators_user), notice: "Indikators user was successfully created."
        end
        format.json { render :show, status: :created, location: @indikators_user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @indikators_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /indikators_users/1 or /indikators_users/1.json
  def update
    respond_to do |format|
      if @indikators_user.update(indikators_user_params)
        format.html do
          redirect_to indikators_user_url(@indikators_user), notice: "Indikators user was successfully updated."
        end
        format.json { render :show, status: :ok, location: @indikators_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @indikators_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indikators_users/1 or /indikators_users/1.json
  def destroy
    @indikators_user.destroy

    respond_to do |format|
      format.html { redirect_to indikators_users_url, notice: "Indikators user was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_indikators_user
    @indikators_user = IndikatorsUser.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def indikators_user_params
    params.require(:indikators_user).permit(:indikator_id, :user_id)
  end
end
