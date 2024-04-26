# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
# Uncomment the following to create an Admin user for Production in Jumpstart Pro
#
#   user = User.create(
#     name: "Admin User",
#     email: "email@example.org",
#     password: "password",
#     password_confirmation: "password",
#     terms_of_service: true
#   )
#   Jumpstart.grant_system_admin!(user)


# ApiRequest.destroy_all

# source = Source.last

# 1000.times do 
#     request = ApiRequest.create(
#         accepted: Faker::Boolean.boolean,
#         api_key: source.source_token.token, 
#         direction: ['inbound','outbound'].sample,
#         request_body: { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, phone: Faker::PhoneNumber.phone_number, address: Faker::Address.street_name },
#         request_time: Faker::Time.between(from: DateTime.now - 10, to: DateTime.now),
#         status: 'pending',
#         test: false,
#         source_id: source.id,
#         campaign_id: source.campaign.id
#     )
# end

# ApiRequest.destroy_all

# campaigns_with_sources_and_distributions = Campaign.includes(:sources, :distributions)
#                                                    .where(account_id: 3)
#                                                    .select { |c| c.sources.any? && c.distributions.any? }


# 2000.times do 
#     # Sample a campaign from the filtered list
#     campaign = campaigns_with_sources_and_distributions.sample

#     # Skip if no campaign is found
#     next unless campaign

#     distribution = campaign.distributions.sample

#     status = ['pending', 'accepted', 'rejected'].sample
#     accepted = (status == 'accepted')

#     request = ApiRequest.create(
#         accepted: accepted,
#         direction: 'outbound',
#         request_body: { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, phone: Faker::PhoneNumber.phone_number, address: Faker::Address.street_name },
#         request_time: Faker::Time.between(from: DateTime.now - 10, to: DateTime.now),
#         status: status,
#         test: false,
#         campaign: campaign,
#         requestable: distribution,
#         created_at: Faker::Time.between(from: 1.month.ago, to: Time.now)
#     )
# end

# 5000.times do 
#     # Sample a campaign from the filtered list
#     campaign = campaigns_with_sources_and_distributions.sample

#     # Skip if no campaign is found
#     next unless campaign

#     source = campaign.sources.sample

#     status = ['pending', 'accepted', 'rejected'].sample
#     accepted = (status == 'accepted')

#     request = ApiRequest.create(
#         accepted: accepted,
#         direction: 'inbound',
#         request_body: { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, phone: Faker::PhoneNumber.phone_number, address: Faker::Address.street_name },
#         request_time: Faker::Time.between(from: DateTime.now - 10, to: DateTime.now),
#         status: status,
#         test: false,
#         campaign: campaign,
#         requestable: source,
#         created_at: Faker::Time.between(from: 1.month.ago, to: Time.now)
#     )
# end


# Check if the source exists and has API requests
# 200.times do |i|
#   campaign = campaigns_with_sources_and_distributions.sample

#   source = campaign.sources.sample

#   if source.api_requests.where(status: 'accepted').any?
#     # Select a random API request from the source's API requests
#     api_request = source.api_requests.where(status: 'accepted').sample

#     # Create a new lead with random data associated with the selected API request
#     api_request.create_lead(
#       bid_cents: rand(1000..5000), # Example range between 10.00 and 50.00 dollars
#       custom_fields: { example_field: "Example Value #{i}" },
#       email: Faker::Internet.email,
#       first_name: Faker::Name.first_name,
#       last_name: Faker::Name.last_name,
#       phone: Faker::PhoneNumber.cell_phone,
#       profit_cents: rand(100..1000), # Example profit range
#       revenue_cents: rand(500..6000), # Example revenue range
#       score: rand(1..100), # Example score range
#       status: Lead.statuses.keys.sample, # Randomly select a status
#       account_id: 3,
#       created_at: Faker::Time.between(from: 1.days.ago, to: Time.now)
#     )
#   end 
# end


# Source.find_each do |source|
#     unless source.source_token
#       source.create_source_token(name: "Token-#{Time.now.to_i}", token: SecureRandom.hex(16), last_used_at: nil, account_id: source.campaign.account_id)
#       puts "Created token for source ##{source.id}"
#     else
#       puts "Source ##{source.id} already has a token."
#     end
#   end



