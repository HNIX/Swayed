class AddRedirectUrlToSource < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :success_redirect_url, :string
    add_column :sources, :failure_redirect_url, :string
  end
end
