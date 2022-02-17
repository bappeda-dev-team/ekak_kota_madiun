# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  kode_opd               :string
#  nama                   :string
#  nik                    :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (kode_opd => opds.kode_opd)
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # validates :nama, presence: true
  # validates :nik, presence: true
  belongs_to :opd, foreign_key: 'kode_opd', primary_key: 'kode_opd'
  has_many :pks
  has_many :kaks
  has_many :sasarans, dependent: :destroy

  def total_user_progress
    self.sasarans.map{ |s| s.rincian.progress_total.nan? ? 0 : s.rincian.progress_total  }.sum
  end

  def avg_user_progress
    self.total_user_progress / self.sasarans.count rescue 0
  end

  def target_renaksi_per_month
    self.sasarans.map{ |s| s.rincian.target_bulan.inject{ | bln, val | bln.merge(val) { | k, old_v, new_v | old_v + new_v } } }
  end

  def sum_target_renaksi_per_month
    # if target_renaksi_per_month != NaN or 0
    unless target_renaksi_per_month.any? { _1.nil?}
    self.target_renaksi_per_month.inject{ | a,b | a.merge(b) { | key, a_val, b_val | a_val + b_val } }
    end
  end

  def realisasi_renaksi_per_month
    self.sasarans.map{ |s| s.rincian.realisasi_bulan.inject{ | bln, val | bln.merge(val) { | k, old_v, new_v | old_v + new_v } } }
  end

  def sum_realisasi_renaksi_per_month
    # if realisasi_renaksi_per_month != NaN or 0
    unless realisasi_renaksi_per_month.any? { _1.nil? }
    self.realisasi_renaksi_per_month.inject{ | a,b | a.merge(b) { | key, a_val, b_val | a_val + b_val } }
    end
  end

  def generate_chart_value
    new_value = []
    data = self.sum_target_renaksi_per_month
    unless data.nil?
      (1..12).map do |bln|
        new_value << data[bln].to_i
      end
    end
    return new_value
  end

  def generate_chart_value_realisasi
    new_value = []
    data = self.sum_realisasi_renaksi_per_month
    unless data.nil?
      (1..12).map do |bln|
        new_value << data[bln].to_i
      end
    end
    return new_value
  end
end
