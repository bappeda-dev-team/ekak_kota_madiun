class TimsController < ApplicationController
  def index
    @tims = Tim.all
  end

  def new
    @tim = Tim.new
    render layout: false
  end

  def edit
    @tim = Tim.find(params[:id])
    render layout: false
  end

  def create
    tim_params = params.require(:tim).permit(:nama_tim, :jenis, :tahun, :keterangan)
    @tim = Tim.new(tim_params)
    if @tim.save
      render json: { resText: "Tim Baru Tersimpan" }.to_json, status: :created
    else
      render json: { resText: "Gagal Menyimpan" }, status: :unprocessable_entity
    end
  end

  def update
    tim_params = params.require(:tim).permit(:nama_tim, :jenis, :tahun, :keterangan)
    @tim = Tim.find(params[:id])
    if @tim.update(tim_params)
      render json: { resText: "Perubahan Tim Tersimpan" }.to_json, status: :ok
    else
      render json: { resText: "Gagal Menyimpan" }, status: :unprocessable_entity
    end
  end
end
