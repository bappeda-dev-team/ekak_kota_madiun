class LembagasController < ApplicationController
  before_action :set_lembaga, only: %i[show edit update destroy]
  def index
    @lembagas = Lembaga.all
  end

  def show; end

  def new
    @lembaga = Lembaga.new
  end

  def edit; end

  def create
    @lembaga = Lembaga.new(lembaga_params)
    respond_to do |format|
      if @lembaga.save
        format.html { redirect_to @lembaga, notice: "Lembaga Berhasil dibut" }
      else
        format.html { render :new, notice: "Gagal Membuat Lembaga" }
      end
    end
  end

  def update
    respond_to do |format|
      if @lembaga.update(lembaga_params)
        format.html { redirect_to @lembaga, notice: "Lembaga diupdate" }
      else
        format.html { render :edit, notice: "Gagal update lembaga" }
      end
    end
  end

  def destroy
    @lembaga.destroy
    respond_to do |format|
      format.html { redirect_to lembagas_url, notice: "Lembaga dihapus" }
    end
  end

  private

  def set_lembaga
    @lembaga = Lembaga.find(params[:id])
  end

  def lembaga_params
    params.require(:lembaga).permit!
  end
end
