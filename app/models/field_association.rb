# == Schema Information
#
# Table name: field_associations
#
#  id             :bigint           not null, primary key
#  fieldable_type :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  field_id       :bigint           not null
#  fieldable_id   :bigint           not null
#
# Indexes
#
#  index_field_associations_on_field_id   (field_id)
#  index_field_associations_on_fieldable  (fieldable_type,fieldable_id)
#
# Foreign Keys
#
#  fk_rails_...  (field_id => fields.id)
#
class FieldAssociation < ApplicationRecord
    belongs_to :field
    belongs_to :fieldable, polymorphic: true
  end
  
