SELECT
  musrenbangs.usulan AS usulan,
  'Musrenbang' AS searchable_type,
  musrenbangs.id AS searchable_id
FROM
  musrenbangs
UNION
SELECT
  pokpirs.usulan AS usulan,
  'Pokpir' AS searchable_type,
  pokpirs.id AS searchable_id
FROM
  pokpirs
UNION
SELECT
  mandatoris.usulan AS usulan,
  'Mandatori' AS searchable_type,
  mandatoris.id AS searchable_id
FROM
  mandatoris
UNION
SELECT
  inovasis.usulan AS usulan,
  'Inovasi' AS searchable_type,
  inovasis.id AS searchable_id
FROM
  inovasis