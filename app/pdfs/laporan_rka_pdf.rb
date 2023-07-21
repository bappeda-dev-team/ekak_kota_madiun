class LaporanRkaPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(opd: '', tahun: '', program_kegiatan: '', sasarans: '')
    super page_size: "LETTER"
    @opd = opd
    @tahun = tahun
    @nama_opd = @opd.nama_opd
    @kota = @opd.lembaga.nama_lembaga
    @program_kegiatan = program_kegiatan
    @sasarans = sasarans
    @pagu = sasarans.map(&:total_anggaran).compact.sum
    indikators_pks = IndikatorQueries.new(tahun: @tahun, opd: @program_kegiatan.opd,
                                          program_kegiatan: @program_kegiatan)
    @indikator_prg = indikators_pks.indikator_program
    @indikator_keg = indikators_pks.indikator_kegiatan
    @indikator_sub = indikators_pks.indikator_subkegiatan
    # @indikator_prg = program_kegiatan&.indikator_program_tahun(tahun, kode_opd)
    # @indikator_keg = program_kegiatan&.indikator_kegiatan_tahun(tahun, kode_opd)
    # @indikator_sub = program_kegiatan&.indikator_subkegiatan_tahun(tahun, kode_opd)
    print
  end

  def print
    title
    move_down 20
    tabel_informasi_subkegiatan
    move_down 30
    rka_content
    move_down 20
    # ttd
  end

  def title
    judul_rka = make_table([["RINCIAN BELANJA"], [@nama_opd], ["Tahun: #{@tahun}"]], width: bounds.width)
    judul_rka.draw
  end

  def ttd
    start_new_page if (cursor - 111).negative?
    bounding_box([bounds.width - 300, cursor - 10], width: bounds.width - 200) do
      text "Madiun,    #{I18n.l Date.today, format: '  %B %Y'}", size: 8, align: :center
      move_down 5
      text "<strong>#{@opd.jabatan_kepala_tanpa_opd}</strong>", size: 8, align: :center,
                                                                inline_format: true
      text "<strong>#{@opd.nama_opd}</strong>", size: 8, align: :center, inline_format: true
      move_down 50
      text "<u>#{@opd.nama_kepala || '!!belum disetting'}</u>", size: 8, align: :center,
                                                                inline_format: true
      text @opd.pangkat_kepala || '!! belum disetting', size: 8, align: :center
      text "NIP. #{@opd.nip_kepala_fix_plt || '!! belum disetting'}", size: 8, align: :center
    end
  end

  def tabel_content(content_tabel)
    table(content_tabel, column_widths: { 0 => 150, 1 => 12 }, cell_style: { size: 8, border_width: 0 },
                         width: bounds.width) do
      cells.style(size: 8)
    end
  end

  def tabel_informasi_subkegiatan
    informasi_subkegiatan = [
      ['Urusan', ':', { content: @program_kegiatan.nama_urusan, font_style: :bold }],
      ['Bidang Urusan', ':', { content: @program_kegiatan.nama_bidang_urusan, font_style: :bold }],
      ['Program', ':', { content: @program_kegiatan.nama_program, font_style: :bold }],
      ['Indikator Kinerja Program', ':', @indikator_prg&.dig(:indikator)],
      ['Target', ':', @indikator_prg&.dig(:target)],
      ['Satuan', ':', @indikator_prg&.dig(:satuan)],
      ['', '', ''],
      ['Kegiatan', ':', { content: @program_kegiatan.nama_kegiatan, font_style: :bold }],
      ['Indikator Kinerja Kegiatan (Output)', ':', @indikator_keg&.dig(:indikator)],
      ['Target', ':', @indikator_keg&.dig(:target)],
      ['Satuan', ':', @indikator_keg&.dig(:satuan)],
      ['', '', ''],
      ['Sub Kegiatan', ':', { content: @program_kegiatan.nama_subkegiatan, font_style: :bold }],
      ['Indikator Kinerja Sub Kegiatan (Output)', ':', @indikator_sub&.dig(:indikator)],
      ['Target', ':', @indikator_sub&.dig(:target)],
      ['Satuan', ':', @indikator_sub&.dig(:satuan)],
      ['Jumlah Sasaran/Rencana Kinerja', ':', @sasarans.size],
      ['Pagu Anggaran', ':',
       "Rp. #{number_with_delimiter(@pagu)}"]
    ]
    tabel_content informasi_subkegiatan
  end

  def rka_content
    move_down 20
    text 'Sumber Dana', style: :bold, indent_paragraphs: 5
    header_sumber_dana = [['No', 'Sasaran', 'Pemilik Sasaran', 'Pagu', 'Sumber Dana']]
    @sasarans.each.with_index(1) do |sasaran_sumber_dana, no|
      header_sumber_dana << [no, sasaran_sumber_dana.sasaran_kinerja,
                             sasaran_sumber_dana.user&.nama,
                             { content: "Rp. #{number_with_delimiter(sasaran_sumber_dana.total_anggaran)}" },
                             sasaran_sumber_dana&.sumber_dana]
    end
    table(header_sumber_dana, cell_style: { size: 8, column_widths: { 0 => 10, 1 => 150, 2 => 50 } },
                              width: bounds.width, position: 5)
    start_new_page

    move_down 5
    font_size 8

    @sasarans.each.with_index(1) do |sasaran, nomor|
      move_down 20
      text "#{nomor}. ", size: 8
      table([
              ["Sasaran/ Rencana Kinerja", ':', sasaran.sasaran_kinerja],
              ['Indikator', ':', sasaran.indikator_kinerja],
              ['Target', ':', "#{sasaran.target} #{sasaran.satuan}"],
              ['Pagu Anggaran', ':',
               "Rp. #{number_with_delimiter(sasaran.total_anggaran)} | Sumber Dana : #{sasaran.sumber_dana}"],
              ['Sub Kegiatan', ':',
               "#{sasaran.program_kegiatan.kode_sub_giat} #{sasaran.program_kegiatan.nama_subkegiatan}" || '-']
            ], cell_style: { borders: [] })
      move_down 5
      # tahapan
      sasaran.tahapans.each.with_index(1) do |tahapan, index|
        move_down 10
        start_new_page if (cursor - 111).negative?
        text "Tahapan #{index}.  #{tahapan.tahapan_kerja}"
        move_down 5
        header_anggaran = [
          [{ content: 'Kode rekening', rowspan: 2 }, { content: 'Uraian', rowspan: 2 },
           { content: 'Rincian Perhitungan', colspan: 4 }, { content: 'Jumlah', rowspan: 2 }],
          %w[Koefisien Satuan Harga PPN]
        ]
        if tahapan.anggarans.exists?
          tahapan.anggarans.each do |anggaran|
            header_anggaran << [rekening_anggaran(anggaran.kode_rek), { content: anggaran.uraian, colspan: 5 },
                                { content: "Rp. #{number_with_delimiter(anggaran.jumlah)}", align: :right }]
            anggaran.perhitungans.each do |perhitungan|
              deskripsi = perhitungan.spesifikasi&.include?('Belanja Gaji') ? perhitungan.deskripsi : uraian_kode(perhitungan.deskripsi)
              header_anggaran << ['', deskripsi, perhitungan.list_koefisien, perhitungan.satuan,
                                  { content: "Rp. #{number_with_delimiter(perhitungan.harga)}", align: :right },
                                  { content: perhitungan.plus_pajak.to_s },
                                  { content: "Rp. #{number_with_delimiter(perhitungan.total)}", align: :right }]
            end
          end
        else
          header_anggaran << ['-', '-', '-', '-', '-', '-', { content: "0", align: :right }]
        end
        table(header_anggaran, cell_style: { size: 6 }, width: bounds.width)
        move_down 5
        text "Pemilik Sasaran : #{sasaran.user&.nama}"
        header_anggaran.clear
      end
    end
  end

  private

  def tabel_maker(data)
    make_table(data) do
      cells.style(size: 8)
    end
  end

  def rekening_anggaran(id_rekening)
    rekening = Rekening.find(id_rekening)
    if rekening
      rekening.kode_rekening
    else
      id_rekening
    end
  end

  def uraian_kode(kode_barang)
    # update using delgate method polymorphic
    Search::AllAnggaran.find_by_kode_barang(kode_barang).uraian_barang
  rescue NoMethodError
    'Tidak Ditemukan'
  end
end
