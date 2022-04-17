class AddUraianToMandatorisAndInovasis < ActiveRecord::Migration[6.1]
  def change
    add_column :musrenbangs, :uraian, :string
    add_column :pokpirs, :uraian, :string
    add_column :mandatoris, :uraian, :string
    add_column :inovasis, :uraian, :string
  end
end
