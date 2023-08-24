class PohonKinerjaPresenter
  attr_accessor :pohon

  delegate :id, :to_param,
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
        @pohon.status == 'diterima' ? 'border border-success pohon-accepted' : 'border border-danger pohon-rejected'
      else
        ''
      end
    else
      ''
    end
  end

  def role
    @pohon.role
  end
end
