class FilterController < ApplicationController
  before_action :filter_params

  def filter_sasaran
    @sasarans = Sasaran.includes([user: :opd]).where(opds: { kode_unik_opd: @kode_opd })
    respond_to do |format|
      format.js { render 'sasarans/sasaran_filter' }
    end
  end

  def filter_user
    @users = User.includes([:opd]).where(opds: { kode_unik_opd: @kode_opd })
    @filter_file = 'hasil_filter' if params[:filter_file].empty?
    respond_to do |format|
      format.js { render 'users/user_filter' }
    end
  end

  def filter_program
    @programKegiatans = ProgramKegiatan.includes(%i[opd subkegiatan_tematik]).where(opds: { kode_unik_opd: @kode_opd })
    respond_to do |format|
      format.js { render 'program_kegiatans/program_kegiatan_filter' }
    end
  end

  private

  def filter_params
    @kode_opd = params[:kode_opd]
    @tahun = params[:tahun]
    @bulan = params[:bulan]
  end
end
