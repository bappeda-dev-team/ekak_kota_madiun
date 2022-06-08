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
UNION
SELECT
    anggaran_bluds.uraian_barang AS uraian_barang,
    anggaran_bluds.kode_barang,
    anggaran_bluds.spesifikasi,
    anggaran_bluds.satuan,
    anggaran_bluds.harga_satuan,
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
    'AnggaranHspkUmum' AS searchable_type,
    anggaran_hspk_umums.id AS searchable_id
FROM
    anggaran_hspk_umums