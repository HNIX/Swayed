class AddNotesToCompany < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :notes, :text
  end
end
