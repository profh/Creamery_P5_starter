class PayGrade < ApplicationRecord
  include AppHelpers::Validations
  include AppHelpers::Deletions
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  # Relationships
  has_many :assignments
  has_many :pay_grade_rates

  # Scopes
  scope :alphabetical, -> { order('level') }

  # Validations
  validates_presence_of :level

  # Callbacks
  before_destroy -> { cannot_destroy_object() }
  
end
