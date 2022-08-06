# Sasaran service for counting each usulan
class SasaranService
  def initialize(sasaran:)
    @sasaran = sasaran
  end

  def status_sasaran
    @sasaran.status_sasaran
  end
end
