class Student < ApplicationRecord
  belongs_to :teacher,class_name: "User"
  validates :teacher,presence: true
  validates :name,presence: true
  validates :email,presence: true,uniqueness: true
  validates :age,presence: true,numericality: { greater_than: 0 }
  validates :course,presence: true
  validates :city,presence: true
  validates :marks,presence: true,numericality: {greater_than_or_equal_to: 0,less_than_or_equal_to: 100}
   scope :search, ->(term) {
    where("name LIKE :search OR email LIKE :search",search: "%#{term}%")
  }

  scope :by_course, ->(course) {
    where(course: course)
  }
  
  def result
    marks >= 35 ? "Pass" : "Fail"
  end
end