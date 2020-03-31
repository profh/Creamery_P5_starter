class PayGradeRate < ApplicationRecord
  include AppHelpers::Validations
  include AppHelpers::Deletions

  # Relationships
  belongs_to :pay_grade

  # Scopes
  scope :current,        -> { where('end_date IS NULL') }
  scope :chronological,  -> { order('start_date') }
  scope :for_pay_grade,  ->(pay_grade) { where('pay_grade_id = ?', pay_grade.id) }
  scope :for_date,       ->(date) { where("start_date <= ? AND (end_date > ? OR end_date IS NULL)", date, date) }

  # Validations
  validates_numericality_of :rate, greater_than: 0

  # Callbacks
  before_destroy -> { cannot_destroy_object() }

end
