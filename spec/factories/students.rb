FactoryBot.define do
  factory :student do
    sequence(:name) { |n| "Student #{n}" }
    sequence(:email) { |n| "student#{n}_#{SecureRandom.hex(4)}@example.com" }
    age { 20 }
    course { "Ruby" }
    city { "New York" }
    marks { 85 }
    association :teacher, factory: [:user, :teacher]

    trait :with_photo do
      after(:build) do |student|
        student.profile_photo.attach(
          io: StringIO.new("fake image data"),
          filename: "profile.jpg",
          content_type: "image/jpeg"
        )
      end
    end

    trait :with_document do
      after(:build) do |student|
        student.documents.attach(
          io: StringIO.new("fake pdf data"),
          filename: "document.pdf",
          content_type: "application/pdf"
        )
      end
    end
  end
end