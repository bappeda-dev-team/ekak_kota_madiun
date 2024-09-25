class TimKerjaController < ApplicationController
  layout false
  # dasar hukum
  def edit_dasar_hukum
    set_dasar_hukum
  end

  def update_dasar_hukum
    set_dasar_hukum

    if @dasar_hukum.update(dasar_hukum_params)
      das_hu = [@dasar_hukum.id, @dasar_hukum.judul_dasar_hukum_tim_kerja]
      render json: { resText: "Perubahan tersimpan",
                     html_content: html_content({ dasar_hukum: das_hu, no: @no },
                                                partial: 'tim_kerja/dasar_hukum') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan",
                     html_content: error_content({ dasar_hukum: @dasar_hukum, no: @no },
                                                 partial: 'tim_kerja/form_dasar_hukum') }.to_json,
             status: :unprocessable_entity
    end
  end

  def hapus_dasar_hukum
    set_dasar_hukum
  end

  # rincian tugas
  def edit_rincian_tugas
    rincian_tugas_id = params[:id]
    @rincian_tugas = Sasaran.find rincian_tugas_id
    @no = params[:no]
  end

  def update_rincian_tugas
    no = params[:no]
    rincian_tugas_id = params[:id]
    @rincian_tugas = Sasaran.find rincian_tugas_id

    if @rincian_tugas.update(rincian_tugas_params)
      tugas = [@rincian_tugas.id, @rincian_tugas.judul_rincian_tugas]
      render json: { resText: "Perubahan tersimpan",
                     html_content: html_content({ tugas: tugas, no: no },
                                                partial: 'tim_kerja/rincian_tugas') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan",
                     html_content: error_content({ rincian_tugas: @rincian_tugas, no: no },
                                                 partial: 'tim_kerja/form_rincian_tugas') }.to_json,
             status: :unprocessable_entity
    end
  end

  def hapus_rincian_tugas
    rincian_tugas_id = params[:id]
    @rincian_tugas = Sasaran.find rincian_tugas_id
  end

  private

  def set_dasar_hukum
    @no = params[:no]
    dasar_hukum_id = params[:id]
    @dasar_hukum = DasarHukum.find dasar_hukum_id
  end

  def dasar_hukum_params
    params.require(:dasar_hukum).permit(:judul_dasar_hukum_tim_kerja, :status_tim_kerja)
  end

  def rincian_tugas_params
    params.require(:sasaran).permit(:judul_rincian_tugas, :status)
  end
end
