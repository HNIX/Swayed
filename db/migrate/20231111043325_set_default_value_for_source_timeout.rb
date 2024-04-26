class SetDefaultValueForSourceTimeout < ActiveRecord::Migration[7.1]
  def change
    change_column_default :sources, :timeout, from: nil, to: 15000
  end
end
