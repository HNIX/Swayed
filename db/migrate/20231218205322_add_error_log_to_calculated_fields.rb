class AddErrorLogToCalculatedFields < ActiveRecord::Migration[7.1]
  def change
    add_column :calculated_fields, :error_log, :jsonb
  end
end
