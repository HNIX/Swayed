class ChangeAssociationOfCalculatedFieldsFromVerticalToCampaign < ActiveRecord::Migration[7.1]
  def change
    remove_reference :calculated_fields, :vertical, index: true, foreign_key: true
    add_reference :calculated_fields, :campaign, null: false, index: true, foreign_key: true
  end
end
