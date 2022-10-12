# GenderAnalysis
# for gender analysis pathway and
# gender budget statement
class GenderAnalysis
  include ActiveModel::Model

  attr_accessor :opd, :tahun

  validates :opd, presence: true
  validates :tahun, presence: true
end
