require 'rails_helper'

RSpec.describe SpipQueries do
  it 'should return daftar_opd' do
    spip = SpipQueries.new()
    expect(spbe.nama_program).to eq('Test program')
  end
end
