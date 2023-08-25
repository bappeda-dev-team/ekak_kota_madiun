class PohonKinerjaPresenter
  attr_accessor :pohon

  delegate :id, :to_param, :metadata,
           to: :pohon
  def initialize(pohon)
    @pohon = pohon
  end

  def pohonable
    @pohon.instance_of?(Pohon) ? @pohon.pohonable : @pohon
  end

  def keterangan
    @pohon.instance_of?(Pohon) ? @pohon.keterangan : ''
  end

  def tombol_partial
    @pohon.instance_of?(Pohon) ? 'pohon_kinerja/item_pohon_tombol' : 'pohon_kinerja/item_pohon_tombol_opd'
  end

  def status
    if @pohon.instance_of?(Pohon)
      if @pohon.status?
        @pohon.status == 'diterima' ? 'pohon-accepted' : 'border border-danger pohon-rejected'
      else
        ''
      end
    else
      ''
    end
  end

  def processed?
    return unless @pohon.instance_of?(Pohon)

    @pohon.status? && @pohon.metadata.key?("processed_by")
  end

  def diproses_oleh
    User.find(@pohon.metadata["processed_by"])
  end

  def diproses_pada
    @pohon.metadata["processed_at"].to_datetime
  end

  def status_ket
    @pohon.status.titleize
  end

  def role
    @pohon.role
  end
end