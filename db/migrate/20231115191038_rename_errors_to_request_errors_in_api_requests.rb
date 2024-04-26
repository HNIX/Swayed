class RenameErrorsToRequestErrorsInApiRequests < ActiveRecord::Migration[7.1]
  def change
    rename_column :api_requests, :errors, :request_errors
  end
end
