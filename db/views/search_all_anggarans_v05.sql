SELECT
    anggaran_sshes.uraian_barang AS uraian_barang,
    anggaran_sshes.kode_barang,
    anggaran_sshes.spesifikasi,
    anggaran_sshes.satuan,
    anggaran_sshes.harga_satuan,
    anggaran_sshes.tahun,
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
    anggaran_sbus.tahun,
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
    anggaran_hspks.tahun,
    'AnggaranHspk' AS searchable_type,
    anggaran_hspks.id AS searchable_id
FROM
    anggaran_hspks
UNION
SELECT
    anggaran_bluds.uraian_barang AS uraian_barang,
    anggaran_bluds.kode_barang,
    anggaran_bluds.spesifikasi,
    anggaran_bluds.satuan,
    anggaran_bluds.harga_satuan,
    anggaran_bluds.tahun,
    'AnggaranBlud' AS searchable_type,
    anggaran_bluds.id AS searchable_id
FROM
    anggaran_bluds
UNION
SELECT
    anggaran_hspk_umums.uraian_barang AS uraian_barang,
    anggaran_hspk_umums.kode_barang,
    anggaran_hspk_umums.spesifikasi,
    anggaran_hspk_umums.satuan,
    anggaran_hspk_umums.harga_satuan,
    anggaran_hspk_umums.tahun,
    'AnggaranHspkUmum' AS searchable_type,
    anggaran_hspk_umums.id AS searchable_id
FROM
    anggaran_hspk_umums
UNION
SELECT
    anggaran_asbs.uraian_barang AS uraian_barang,
    anggaran_asbs.kode_barang,
    anggaran_asbs.spesifikasi,
    anggaran_asbs.satuan,
    anggaran_asbs.harga_satuan,
    anggaran_asbs.tahun,
    'AnggaranAsb' AS searchable_type,
    anggaran_asbs.id AS searchable_id
FROM
    anggaran_asbs