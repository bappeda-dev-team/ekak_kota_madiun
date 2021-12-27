class KaksController < ApplicationController
  before_action :set_user
  before_action :set_kak, only: %i[ show edit update destroy ]

  # GET /kaks or /kaks.json
  def index
    @kaks = @user.kaks
  end

  # GET /kaks/1 or /kaks/1.json
  def show
  end

  # GET /kaks/new
  def new
    @kak = @user.kaks.build
  end

  # GET /kaks/1/edit
  def edit
  end

  # POST /kaks or /kaks.json
  def create
    @kak = @user.kaks.build(kak_params)

    respond_to do |format|
      if @kak.save
        format.html { redirect_to user_kaks_path(@user), notice: "Kak was successfully created." }
        format.json { render :show, status: :created, location: @kak }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @kak.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kaks/1 or /kaks/1.json
  def update
    respond_to do |format|
      if @kak.update(kak_params)
        format.html { redirect_to @kak, notice: "Kak was successfully updated." }
        format.json { render :show, status: :ok, location: @kak }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kak.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kaks/1 or /kaks/1.json
  def destroy
    @kak.destroy
    respond_to do |format|
      format.html { redirect_to kaks_url, notice: "Kak was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_kak
      @kak = @user.kaks.find(params[:id])
    end
    
    # Only allow a list of trusted parameters through.
    def kak_params
      params.require(:kak).permit({:dasar_hukum => []}, {:tujuan => []}, :user_id, :program_kegiatan_id)
    end
end
