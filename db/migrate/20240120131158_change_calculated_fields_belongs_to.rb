class ChangeCalculatedFieldsBelongsTo < ActiveRecord::Migration[7.1]
  def change
    remove_reference :calculated_fields, :campaign, foreign_key: true
    add_reference :calculated_fields, :vertical, null: false, foreign_key: true
  end
end
