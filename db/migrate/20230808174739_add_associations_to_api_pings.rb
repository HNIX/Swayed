class AddAssociationsToApiPings < ActiveRecord::Migration[7.0]
  def change
    add_reference :api_pings, :source, null: false, foreign_key: true
    remove_reference :api_pings, :campaign_source, index: true
  end
end
