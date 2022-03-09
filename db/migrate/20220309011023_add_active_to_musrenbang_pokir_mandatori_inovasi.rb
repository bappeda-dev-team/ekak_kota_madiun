class AddActiveToMusrenbangPokirMandatoriInovasi < ActiveRecord::Migration[6.1]
  def change
    add_column :musrenbangs, :is_active, :boolean, default: 0
    add_column :pokpirs, :is_active, :boolean, default: 0
    add_column :mandatoris, :is_active, :boolean, default: 0
    add_column :inovasis, :is_active, :boolean, default: 0
  end
end
