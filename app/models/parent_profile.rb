class ParentProfile < ApplicationRecord
  has_one :parent

  belongs_to :primary_contact,     class_name: ContactInfo
  belongs_to :emergency_contact,   class_name: ContactInfo
  belongs_to :emergency_contact_2, class_name: ContactInfo
end
