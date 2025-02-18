json.results do
  @misis.each do |visi, misis|
    misis.each do |misi|
      json.child! do
        json.id misi.id
        json.visi visi.visi_with_urutan_and_lembaga
        json.text misi.misi_with_urutan
      end
    end
  end
end
