class Student < ApplicationRecord
  belongs_to :teacher, class_name: "User"

  validates :teacher, presence: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :age, presence: true,
                  numericality: { greater_than: 0 }
  validates :course, presence: true
  validates :city, presence: true
  validates :marks, presence: true,
                    numericality: {
                      greater_than_or_equal_to: 0,
                      less_than_or_equal_to: 100
                    }

  COURSES = %w[Ruby Rails React Java].freeze

  PASS_MARK = 35

  GRADE_RANGES = {
    'A' => 85..100,
    'B' => 70..84,
    'C' => 50..69,
    'D' => 35..49,
    'F' => 0..34
  }.freeze

  scope :search, ->(term) {
    term.present? ? where(
      "name LIKE :search OR email LIKE :search",
      search: "%#{term}%"
    ) : all
  }
  
  scope :by_course, ->(course) {
    where(course: course)
  }
  scope :by_grade, ->(grade) {
    range = GRADE_RANGES[grade.to_s.upcase]
    range ? where(marks: range) : none
  }

  def grade
    GRADE_RANGES.find { |_, range| range.include?(marks.to_i) }&.first || 'F'
  end

    scope :by_name, ->(name) {
    where("name LIKE ?", "%#{name}%")
  }

  scope :by_grade, ->(grade) {
    case grade.upcase
    when "A"
      where(marks: 90..100)
    when "B"
      where(marks: 80...90)
    when "C"
      where(marks: 70...80)
    when "D"
      where(marks: 60...70)
    when "F"
      where(marks: 0...60)
    else
      none
    end
  }

  def result
    marks >= PASS_MARK ? "Pass" : "Fail"
  end

  def as_json(options = {})
    super(options).merge('grade' => grade, 'result' => result)
  end
end