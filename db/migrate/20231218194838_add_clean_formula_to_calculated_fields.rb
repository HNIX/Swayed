class AddCleanFormulaToCalculatedFields < ActiveRecord::Migration[7.1]
  def change
    add_column :calculated_fields, :clean_formula, :string
  end
end
