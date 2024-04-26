class AddDefaultValueToStatusInCalculatedFields < ActiveRecord::Migration[7.1]
  def change
    change_column_default :calculated_fields, :status, from: nil, to: 0
  end
end
