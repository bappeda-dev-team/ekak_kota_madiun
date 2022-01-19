class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # validates :nama, presence: true
  # validates :nik, presence: true
  belongs_to :opd
  has_many :pks
  has_many :kaks
  has_many :sasarans, dependent: :destroy

  def total_user_progress
    self.sasarans.map{ |s| s.rincian.progress_total.nan? ? 0 : s.rincian.progress_total  }.sum
  end

  def target_renaksi_per_month
    self.sasarans.map{ |s| s.rincian.target_bulan.inject{ | bln, val | bln.merge(val) { | k, old_v, new_v | old_v + new_v } } }      
  end

  def sum_target_renaksi_per_month
    # if target_renaksi_per_month != NaN or 0
    self.target_renaksi_per_month.inject{ | a,b | a.merge(b) { | key, a_val, b_val | a_val + b_val } }
  end

  def realisasi_renaksi_per_month
    self.sasarans.map{ |s| s.rincian.realisasi_bulan.inject{ | bln, val | bln.merge(val) { | k, old_v, new_v | old_v + new_v } } }      
  end

  def sum_realisasi_renaksi_per_month
    # if realisasi_renaksi_per_month != NaN or 0
    self.realisasi_renaksi_per_month.inject{ | a,b | a.merge(b) { | key, a_val, b_val | a_val + b_val } }
  end

  def generate_chart_value
    new_value = []
    data = self.sum_target_renaksi_per_month
    (1..12).map do |bln|
      new_value << data[bln].to_i
    end
    return new_value
  end

  def generate_chart_value_realisasi
    new_value = []
    data = self.sum_realisasi_renaksi_per_month
    (1..12).map do |bln|
      new_value << data[bln].to_i
    end
    return new_value
  end
end
