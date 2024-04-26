class RemoveNullConstraintFromSourcesCompanyId < ActiveRecord::Migration[7.1]
  def change
    change_column_null :sources, :company_id, true
  end
end
