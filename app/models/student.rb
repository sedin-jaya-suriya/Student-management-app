class Student < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  has_one_attached :profile_photo
  has_one_attached :report_card
  has_many_attached :documents

  validates :teacher, presence: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :age,
            presence: true,
            numericality: { greater_than: 0 }
  validates :course, presence: true
  validates :city, presence: true
  validates :marks,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100
            }

  validate :profile_photo_validation
  validate :document_validation


  COURSES = %w[Ruby Rails React Java].freeze

  PASS_MARK = 35

  GRADE_RANGES = {
    "A" => 85..100,
    "B" => 70..84,
    "C" => 50..69,
    "D" => 35..49,
    "F" => 0..34
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

  scope :by_name, ->(name) {
    where("name LIKE ?", "%#{name}%")
  }

  scope :by_grade, ->(grade) {
    range = GRADE_RANGES[grade.to_s.upcase]
    range ? where(marks: range) : none
  }

  def grade
    GRADE_RANGES.find { |_, range| range.include?(marks.to_i) }&.first || "F"
  end

  def result
    marks >= PASS_MARK ? "Pass" : "Fail"
  end

  def as_json(options = {})
    super(options).merge(
      "grade" => grade,
      "result" => result
    )
  end

  private
    def profile_photo_validation
        return unless profile_photo.attached?
        unless profile_photo.content_type.in?(%w[image/jpeg image/png image/jpg])
            errors.add(:profile_photo, "Must be in the JPG, JPEG, or PNG")
        end

        if profile_photo.blob.byte_size>5.megabytes
            errors.add(:profile_photo, "Must be below 5 MB")
        end
    end

    def document_validation
      return unless documents.attached?
        documents.each do |doc|
            unless doc.content_type.in?(
                %w[application/pdf image/jpeg image/png image/jpg]
            )
                errors.add(:documents, "must be PDF, JPG, JPEG, or PNG")
            end

            if doc.blob.byte_size>10.megabytes
                errors.add(:documents, "Must be below 10 MB")
            end
        end
    end
end
