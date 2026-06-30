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

  scope :search, ->(term) {
    where(
      "name LIKE :search OR email LIKE :search",
      search: "%#{term}%"
    )
  }

  scope :by_course, ->(course) {
    where(course: course)
  }

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
    marks >= 35 ? "Pass" : "Fail"
  end
end