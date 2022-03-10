SELECT
  anggaran_sshes.uraian_barang AS uraian_barang,
  anggaran_sshes.kode_barang,
  anggaran_sshes.spesifikasi,
  anggaran_sshes.satuan,
  anggaran_sshes.harga_satuan,
  'AnggaranSsh' AS searchable_type,
  anggaran_sshes.id AS searchable_id
FROM
  anggaran_sshes
UNION
SELECT
  anggaran_sbus.uraian_barang AS uraian_barang,
  anggaran_sbus.kode_barang,
  anggaran_sbus.spesifikasi,
  anggaran_sbus.satuan,
  anggaran_sbus.harga_satuan,
  'AnggaranSbu' AS searchable_type,
  anggaran_sbus.id AS searchable_id
FROM
  anggaran_sbus
UNION
SELECT
  anggaran_hspks.uraian_barang AS uraian_barang,
  anggaran_hspks.kode_barang,
  anggaran_hspks.spesifikasi,
  anggaran_hspks.satuan,
  anggaran_hspks.harga_satuan,
  'AnggaranHspk' AS searchable_type,
  anggaran_hspks.id AS searchable_id
FROM
  anggaran_hspks