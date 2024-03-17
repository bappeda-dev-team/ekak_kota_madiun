SELECT
  musrenbangs.usulan AS usulan,
  musrenbangs.sasaran_id,
  'Musrenbang' AS searchable_type,
  musrenbangs.id AS searchable_id,
  musrenbangs.tahun,
  musrenbangs.nip_asn
FROM
  musrenbangs
WHERE
  musrenbangs.is_active = 'yes'
UNION
SELECT
  pokpirs.usulan AS usulan,
  pokpirs.sasaran_id,
  'Pokpir' AS searchable_type,
  pokpirs.id AS searchable_id,
  pokpirs.tahun,
  pokpirs.nip_asn
FROM
  pokpirs
WHERE
  pokpirs.is_active = 'yes'
UNION
SELECT
  mandatoris.usulan AS usulan,
  mandatoris.sasaran_id,
  'Mandatori' AS searchable_type,
  mandatoris.id AS searchable_id,
  mandatoris.tahun,
  mandatoris.nip_asn
FROM
  mandatoris
WHERE
  mandatoris.is_active = 'yes'
UNION
SELECT
  inovasis.usulan AS usulan,
  inovasis.sasaran_id,
  'Inovasi' AS searchable_type,
  inovasis.id AS searchable_id,
  inovasis.tahun,
  inovasis.nip_asn
FROM
  inovasis
WHERE
  inovasis.is_active = 'yes'