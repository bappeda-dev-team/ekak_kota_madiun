# == Schema Information
#
# Table name: kriteria
#
#  id            :bigint           not null, primary key
#  keterangan    :string
#  kriteria      :string
#  poin          :integer
#  poin_max      :integer
#  poin_min      :integer
#  tipe_kriteria :string
#  type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  kriteria_id   :bigint
#
class SubKriterium < Kriterium
  def to_s
    kriteria
  end
end
