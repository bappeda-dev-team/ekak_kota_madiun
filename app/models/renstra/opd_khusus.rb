module Renstra::OpdKhusus
  OPD_TABLE = {
    'Rumah Sakit Umum Daerah Kota Madiun': "Rumah Sakit Umum Daerah",
    'Sekretariat Daerah': "Sekretaris Daerah",
    'Bagian Umum': "Bagian Umum",
    'Bagian Pengadaan Barang/Jasa dan Administrasi Pembangunan': "Bagian Pengadaan Barang/Jasa dan Administrasi Pembangunan",
    'Bagian Organisasi': "Bagian Organisasi",
    'Bagian Hukum': "Bagian Hukum",
    'Bagian Perekonomian dan Kesejahteraan Rakyat': "Bagian Perekonomian dan Kesejahteraan Rakyat",
    'Bagian Pemerintahan': "Bagian Pemerintahan"
  }.freeze

  KODE_OPD_TABLE = {
    'Rumah Sakit Umum Daerah Kota Madiun': "1.02.2.14.0.00.03.0000",
    'Sekretariat Daerah': "4.01.0.00.0.00.01.00", # don't change, this still used
    'Bagian Umum': "4.01.0.00.0.00.01.00",
    'Bagian Pengadaan Barang/Jasa dan Administrasi Pembangunan': "4.01.0.00.0.00.01.00",
    'Bagian Organisasi': "4.01.0.00.0.00.01.00",
    'Bagian Hukum': "4.01.0.00.0.00.01.00",
    'Bagian Perekonomian dan Kesejahteraan Rakyat': "4.01.0.00.0.00.01.00",
    'Bagian Pemerintahan': "4.01.0.00.0.00.01.00"
  }.freeze

  KODE_OPD_BAGIAN = {
    'Rumah Sakit Umum Daerah Kota Madiun': "3408",
    'Sekretariat Daerah': "479", # don't change, this still used
    'Bagian Umum': "4402",
    'Bagian Pengadaan Barang/Jasa dan Administrasi Pembangunan': "4400",
    'Bagian Organisasi': "4398",
    'Bagian Hukum': "4399",
    'Bagian Perekonomian dan Kesejahteraan Rakyat': "4401",
    'Bagian Pemerintahan': "4397"
  }.freeze

  KODE_BAGIAN_SETDA = {
    '4.01.0.00.0.00.01.0001' => 'Bagian Pemerintahan',
    '4.01.0.00.0.00.01.0002' => 'Bagian Organisasi',
    '4.01.0.00.0.00.01.0003' => 'Bagian Hukum',
    '4.01.0.00.0.00.01.0004' => 'Bagian Pengadaan Barang/Jasa dan Administrasi Pembangunan',
    '4.01.0.00.0.00.01.0005' => 'Bagian Perekonomian dan Kesejahteraan Rakyat',
    '4.01.0.00.0.00.01.0006' => 'Bagian Umum'
  }.freeze
end
