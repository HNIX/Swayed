class AddResponseTokensToDistributions < ActiveRecord::Migration[7.0]
  def change
    add_column :distributions, :response_mapping, :jsonb
    add_column :distributions, :response_format, :string
  end
end
