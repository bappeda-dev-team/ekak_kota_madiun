# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenstraRowComponent, type: :component do
  context 'subkegiatan' do
    it "replace last XX kode with 00XX for subkegiatan" do
      # Arrange
      row_component = RenstraRowComponent.new(program: { kode: '4.01.02.2.01.01', jenis: 'subkegiatan' })

      # Act
      new_kode = row_component.kode_tweak

      # Assert
      expect(new_kode).to eq('4.01.02.2.01.0001')
    end
  end
end
