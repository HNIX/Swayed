class AddAssociationsToSources < ActiveRecord::Migration[7.0]
  def change
    add_reference :sources, :campaign, null: false, foreign_key: true
    remove_reference :sources, :vertical, index: true, foreign_key: true
  end
end
