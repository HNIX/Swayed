# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_07_013914) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "account_invitations", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "invited_by_id"
    t.string "token", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.jsonb "roles", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_invitations_on_account_id"
    t.index ["invited_by_id"], name: "index_account_invitations_on_invited_by_id"
    t.index ["token"], name: "index_account_invitations_on_token", unique: true
  end

  create_table "account_users", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "user_id"
    t.jsonb "roles", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_users_on_account_id"
    t.index ["user_id"], name: "index_account_users_on_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "owner_id"
    t.boolean "personal", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "extra_billing_info"
    t.string "domain"
    t.string "subdomain"
    t.string "billing_email"
    t.integer "account_users_count", default: 0
    t.index ["owner_id"], name: "index_accounts_on_owner_id"
  end

  create_table "action_text_embeds", force: :cascade do |t|
    t.string "url"
    t.jsonb "fields"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.integer "address_type"
    t.string "line1"
    t.string "line2"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "affiliates", force: :cascade do |t|
    t.jsonb "metadata", default: {}
    t.string "name"
    t.string "email"
    t.string "phone"
    t.bigint "account_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_affiliates_on_account_id"
    t.index ["user_id"], name: "index_affiliates_on_user_id"
  end

  create_table "announcements", force: :cascade do |t|
    t.string "kind"
    t.string "title"
    t.datetime "published_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_request_leads", force: :cascade do |t|
    t.uuid "api_request_id", null: false
    t.bigint "lead_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_request_id"], name: "index_api_request_leads_on_api_request_id"
    t.index ["lead_id"], name: "index_api_request_leads_on_lead_id"
  end

  create_table "api_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "accepted"
    t.boolean "lead_posted"
    t.integer "price"
    t.integer "direction", default: 0
    t.jsonb "request_body"
    t.jsonb "response_body"
    t.integer "status"
    t.boolean "test"
    t.integer "response_code"
    t.bigint "campaign_id", null: false
    t.bigint "source_id"
    t.bigint "distribution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "endpoint"
    t.string "method_type"
    t.string "source_ip"
    t.text "errors"
    t.string "api_key"
    t.jsonb "headers"
    t.datetime "request_time"
    t.index ["campaign_id"], name: "index_api_requests_on_campaign_id"
    t.index ["distribution_id"], name: "index_api_requests_on_distribution_id"
    t.index ["source_id"], name: "index_api_requests_on_source_id"
  end

  create_table "api_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token"
    t.string "name"
    t.jsonb "metadata", default: {}
    t.boolean "transient", default: false
    t.datetime "last_used_at", precision: nil
    t.datetime "expires_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_api_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_api_tokens_on_user_id"
  end

  create_table "campaign_distributions", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.bigint "distribution_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "field_mapping"
    t.index ["campaign_id"], name: "index_campaign_distributions_on_campaign_id"
    t.index ["distribution_id"], name: "index_campaign_distributions_on_distribution_id"
  end

  create_table "campaign_fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.integer "data_type"
    t.boolean "validated"
    t.boolean "post_required"
    t.boolean "ping_required"
    t.boolean "hide"
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_pii"
    t.string "example_value"
    t.integer "position"
    t.boolean "post_only", default: false
    t.index ["campaign_id"], name: "index_campaign_fields_on_campaign_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.bigint "vertical_id", null: false
    t.bigint "account_id", null: false
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.integer "campaign_type", default: 0
    t.integer "distribution_method"
    t.boolean "distribution_schedule_enabled"
    t.time "distribution_schedule_start_time"
    t.time "distribution_schedule_end_time"
    t.string "distribution_schedule_days", default: [], array: true
    t.index ["account_id"], name: "index_campaigns_on_account_id"
    t.index ["vertical_id"], name: "index_campaigns_on_vertical_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "payment_terms"
    t.string "billing_cycle"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "tax_id"
    t.string "currency"
    t.integer "payment_threshold"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.text "notes"
    t.index ["account_id"], name: "index_companies_on_account_id"
  end

  create_table "connected_accounts", force: :cascade do |t|
    t.bigint "owner_id"
    t.string "provider"
    t.string "uid"
    t.string "refresh_token"
    t.datetime "expires_at", precision: nil
    t.text "auth"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "access_token"
    t.string "access_token_secret"
    t.string "owner_type"
    t.index ["owner_id", "owner_type"], name: "index_connected_accounts_on_owner_id_and_owner_type"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_contacts_on_company_id"
  end

  create_table "distributions", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "endpoint"
    t.string "key"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "response_mapping"
    t.string "response_format"
    t.jsonb "template"
    t.string "name"
    t.integer "request_format"
    t.integer "request_method"
    t.boolean "headers"
    t.boolean "request_body_all_fields"
    t.boolean "conditional_logic_enabled"
    t.boolean "headers_option"
    t.boolean "select_fields"
    t.index ["company_id"], name: "index_distributions_on_company_id"
  end

  create_table "fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "data_type"
    t.boolean "validated", default: false
    t.boolean "post_required", default: false
    t.boolean "ping_required", default: false
    t.boolean "hide", default: false
    t.bigint "vertical_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "example_value"
    t.index ["label", "vertical_id"], name: "index_fields_on_label_and_vertical_id", unique: true
    t.index ["name", "vertical_id"], name: "index_fields_on_name_and_vertical_id", unique: true
    t.index ["vertical_id"], name: "index_fields_on_vertical_id"
  end

  create_table "headers", force: :cascade do |t|
    t.string "name"
    t.string "header_value"
    t.bigint "distribution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["distribution_id"], name: "index_headers_on_distribution_id"
  end

  create_table "inbound_webhooks", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leads", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.jsonb "custom_fields", default: {}, null: false
    t.integer "status", default: 0
    t.integer "score"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "revenue_cents"
    t.integer "profit_cents"
    t.integer "bid_cents"
  end

  create_table "mapped_fields", force: :cascade do |t|
    t.string "name"
    t.string "static_value"
    t.bigint "campaign_field_id"
    t.bigint "campaign_distribution_id", null: false
    t.boolean "is_static", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_distribution_id"], name: "index_mapped_fields_on_campaign_distribution_id"
    t.index ["campaign_field_id"], name: "index_mapped_fields_on_campaign_field_id"
  end

  create_table "notification_tokens", force: :cascade do |t|
    t.bigint "user_id"
    t.string "token", null: false
    t.string "platform", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notification_tokens_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type"
    t.jsonb "params"
    t.datetime "read_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "interacted_at", precision: nil
    t.index ["account_id"], name: "index_notifications_on_account_id"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient_type_and_recipient_id"
  end

  create_table "pay_charges", force: :cascade do |t|
    t.string "processor_id", null: false
    t.integer "amount", null: false
    t.integer "amount_refunded"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.jsonb "data"
    t.integer "application_fee_amount"
    t.string "currency"
    t.jsonb "metadata"
    t.integer "subscription_id"
    t.bigint "customer_id"
    t.index ["customer_id", "processor_id"], name: "index_pay_charges_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_customers", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "processor"
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id", "deleted_at"], name: "customer_owner_processor_index"
    t.index ["processor", "processor_id"], name: "index_pay_customers_on_processor_and_processor_id"
  end

  create_table "pay_merchants", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "processor"
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id", "processor"], name: "index_pay_merchants_on_owner_type_and_owner_id_and_processor"
  end

  create_table "pay_payment_methods", force: :cascade do |t|
    t.bigint "customer_id"
    t.string "processor_id"
    t.boolean "default"
    t.string "type"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "processor_id"], name: "index_pay_payment_methods_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_subscriptions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "processor_id", null: false
    t.string "processor_plan", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "trial_ends_at", precision: nil
    t.datetime "ends_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "status"
    t.jsonb "data"
    t.decimal "application_fee_percent", precision: 8, scale: 2
    t.jsonb "metadata"
    t.bigint "customer_id"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.boolean "metered"
    t.string "pause_behavior"
    t.datetime "pause_starts_at"
    t.datetime "pause_resumes_at"
    t.index ["customer_id", "processor_id"], name: "index_pay_subscriptions_on_customer_id_and_processor_id", unique: true
    t.index ["metered"], name: "index_pay_subscriptions_on_metered"
    t.index ["pause_starts_at"], name: "index_pay_subscriptions_on_pause_starts_at"
  end

  create_table "pay_webhooks", force: :cascade do |t|
    t.string "processor"
    t.string "event_type"
    t.jsonb "event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string "name", null: false
    t.integer "amount", default: 0, null: false
    t.string "interval", null: false
    t.jsonb "details", default: {}, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "trial_period_days", default: 0
    t.boolean "hidden"
    t.string "currency"
    t.integer "interval_count", default: 1
    t.string "description"
    t.string "unit_label"
    t.boolean "charge_per_unit"
  end

  create_table "rules_rule_sets", force: :cascade do |t|
    t.string "rule_source_type"
    t.bigint "rule_source_id"
    t.string "evaluation_logic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rule_source_type", "rule_source_id"], name: "index_rules_rule_sets_on_rule_source"
  end

  create_table "rules_rules", force: :cascade do |t|
    t.bigint "rule_set_id"
    t.text "expression"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rule_set_id"], name: "index_rules_rules_on_rule_set_id"
  end

  create_table "source_tokens", force: :cascade do |t|
    t.datetime "expires_at"
    t.datetime "last_used_at"
    t.jsonb "metadata", default: {}
    t.string "name"
    t.string "token"
    t.boolean "transient", default: false
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "source_id"
    t.index ["account_id"], name: "index_source_tokens_on_account_id"
    t.index ["name"], name: "index_source_tokens_on_name", unique: true
    t.index ["source_id"], name: "index_source_tokens_on_source_id"
    t.index ["token"], name: "index_source_tokens_on_token", unique: true
  end

  create_table "sources", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "terms"
    t.integer "status", default: 0
    t.string "landing_page_url"
    t.string "privacy_policy_url"
    t.string "postback_url"
    t.integer "payout_method"
    t.integer "payout"
    t.integer "budget"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "offer_type"
    t.bigint "campaign_id", null: false
    t.decimal "margin"
    t.decimal "minimum_acceptable_bid"
    t.integer "integration_type"
    t.text "description"
    t.integer "payout_structure"
    t.string "unique_source_id"
    t.integer "traffic_sources"
    t.string "tracking_url"
    t.string "success_redirect_url"
    t.string "failure_redirect_url"
    t.boolean "shared"
    t.integer "timeout"
    t.index ["campaign_id"], name: "index_sources_on_campaign_id"
    t.index ["company_id"], name: "index_sources_on_company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.string "first_name"
    t.string "last_name"
    t.string "time_zone"
    t.datetime "accepted_terms_at", precision: nil
    t.datetime "accepted_privacy_at", precision: nil
    t.datetime "announcements_read_at", precision: nil
    t.boolean "admin"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at", precision: nil
    t.datetime "invitation_sent_at", precision: nil
    t.datetime "invitation_accepted_at", precision: nil
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "preferred_language"
    t.boolean "otp_required_for_login"
    t.string "otp_secret"
    t.integer "last_otp_timestep"
    t.text "otp_backup_codes"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "validations", force: :cascade do |t|
    t.integer "validation_type"
    t.integer "min_value"
    t.integer "max_value"
    t.date "value_date_start"
    t.date "value_date_end"
    t.string "value_text"
    t.string "operator"
    t.bigint "campaign_field_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "value_integer"
    t.date "value_date"
    t.boolean "value_boolean"
    t.index ["campaign_field_id"], name: "index_validations_on_campaign_field_id"
  end

  create_table "verticals", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "secondary_category"
    t.integer "primary_category"
    t.boolean "archived"
    t.boolean "base", default: false
    t.index ["account_id"], name: "index_verticals_on_account_id"
  end

  add_foreign_key "account_invitations", "accounts"
  add_foreign_key "account_invitations", "users", column: "invited_by_id"
  add_foreign_key "account_users", "accounts"
  add_foreign_key "account_users", "users"
  add_foreign_key "accounts", "users", column: "owner_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "affiliates", "accounts"
  add_foreign_key "affiliates", "users"
  add_foreign_key "api_request_leads", "api_requests"
  add_foreign_key "api_request_leads", "leads"
  add_foreign_key "api_requests", "campaigns"
  add_foreign_key "api_requests", "distributions"
  add_foreign_key "api_requests", "sources"
  add_foreign_key "api_tokens", "users"
  add_foreign_key "campaign_distributions", "campaigns"
  add_foreign_key "campaign_distributions", "distributions"
  add_foreign_key "campaign_fields", "campaigns"
  add_foreign_key "campaigns", "accounts"
  add_foreign_key "campaigns", "verticals"
  add_foreign_key "contacts", "companies"
  add_foreign_key "distributions", "companies"
  add_foreign_key "fields", "verticals"
  add_foreign_key "headers", "distributions"
  add_foreign_key "mapped_fields", "campaign_distributions"
  add_foreign_key "mapped_fields", "campaign_fields"
  add_foreign_key "pay_charges", "pay_customers", column: "customer_id"
  add_foreign_key "pay_payment_methods", "pay_customers", column: "customer_id"
  add_foreign_key "pay_subscriptions", "pay_customers", column: "customer_id"
  add_foreign_key "source_tokens", "accounts"
  add_foreign_key "source_tokens", "sources"
  add_foreign_key "sources", "campaigns"
  add_foreign_key "sources", "companies"
  add_foreign_key "validations", "campaign_fields"
  add_foreign_key "verticals", "accounts"
end
