require 'rails_helper'

RSpec.describe 'laporan_kak_pdf' do
  def setup
    @tahun = '2024'
    @user = create(:eselon_4)
    @program_kegiatan = create(:program_kegiatan)
    @sasaran = create(:sasaran_subkegiatan,
                     tahun: @tahun,
                     user: @user,
                     metadata: {
                       hasil_inovasi: 'Inovasi',
                       jenis_inovasi: 'Baru',
                       inovasi_sasaran: 'Inovasi-x',
                       gambaran_nilai_kebaruan: 'Gambaran-x'
                     },
                     program_kegiatan: @program_kegiatan)
    @sasarans = @program_kegiatan.sasarans_subkegiatan(@tahun)
    @opd = @user.opd
  end

  it 'should render laporan kak pdf' do
    setup
    pdf = LaporanKakPdf.new(opd: @opd,
                            tahun: @tahun,
                            program_kegiatan: @program_kegiatan,
                            sasarans: @sasarans)
    rendered_pdf = pdf.render
    text_analysis = PDF::Inspector::Text.analyze(rendered_pdf).strings

    # judul
    expect(text_analysis).to include('KERANGKA ACUAN KERJA/ TERM OF REFERENCE')
    expect(text_analysis).to include("KELUARAN (OUTPUT) KEGIATAN TA #{@tahun}")

    # sasaran / detail
    expect(text_analysis).to include("Dasar Hukum")
    expect(text_analysis).to include("Sasaran/Rencana Kinerja")
    expect(text_analysis).to include(@sasaran.sasaran_kinerja.strip)

    # inovasi
    expect(text_analysis).to include("i.1", "Judul inovasi", "Inovasi-x")
    expect(text_analysis).to include("i.2", "Jenis inovasi", "Baru")
    expect(text_analysis).to include("i.3", "Nilai kebaruan", "Gambaran-x")
  end
end
