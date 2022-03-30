class FilterController < ApplicationController
  before_action :filter_params

  def filter_sasaran
    @sasarans = Sasaran.joins(user: :opd).where(opds: { kode_unik_opd: @kode_opd })
    respond_to do |format|
      format.js { render 'sasarans/sasaran_filter' }
    end
  end

  private

  def filter_params
    @kode_opd = params[:kode_opd]
    @tahun = params[:tahun]
    @bulan = params[:bulan]
  end
end
