require 'rails_helper'

RSpec.describe Student, type: :model do
  describe "validations" do
    subject { build(:student) }

    it { should validate_presence_of(:teacher) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age).is_greater_than(0) }
    it { should validate_presence_of(:course) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:marks) }
    it { should validate_numericality_of(:marks).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }
  end

  describe "associations" do
    it { should belong_to(:teacher).class_name('User') }
    it { should have_one_attached(:profile_photo) }
    it { should have_one_attached(:report_card) }
    it { should have_many_attached(:documents) }
  end

  describe "custom validations" do
    let(:student) { build(:student) }

    context "profile_photo" do
      it "is valid with a valid photo" do
        student.profile_photo.attach(io: StringIO.new("fake image data"), filename: "test.jpg", content_type: "image/jpeg")
        expect(student).to be_valid
      end

      it "is invalid with wrong content type" do
        student.profile_photo.attach(io: StringIO.new("fake image data"), filename: "test.pdf", content_type: "application/pdf")
        student.valid?
        expect(student.errors[:profile_photo]).to include("Must be in the JPG, JPEG, or PNG")
      end
    end

    context "documents" do
      it "is valid with a valid document" do
        student.documents.attach(io: StringIO.new("fake document data"), filename: "test.pdf", content_type: "application/pdf")
        expect(student).to be_valid
      end

      it "is invalid with wrong content type" do
        student.documents.attach(io: StringIO.new("fake document data"), filename: "test.txt", content_type: "text/plain")
        student.valid?
        expect(student.errors[:documents]).to include("must be PDF, JPG, JPEG, or PNG")
      end
    end
  end

  describe "scopes" do
    let!(:student1) { create(:student, name: "Alice", email: "alice@example.com", course: "Ruby", marks: 95) }
    let!(:student2) { create(:student, name: "Bob", email: "bob@test.com", course: "Rails", marks: 75) }
    let!(:student3) { create(:student, name: "Charlie", email: "charlie@example.com", course: "Ruby", marks: 50) }

    describe ".search" do
      it "returns students matching the name or email" do
        expect(Student.search("Alice")).to include(student1)
        expect(Student.search("Alice")).not_to include(student2)
        expect(Student.search("test.com")).to include(student2)
      end
    end

    describe ".by_course" do
      it "returns students for the specific course" do
        expect(Student.by_course("Ruby")).to include(student1, student3)
        expect(Student.by_course("Ruby")).not_to include(student2)
      end
    end

    describe ".by_name" do
      it "returns students matching the name" do
        expect(Student.by_name("Bob")).to include(student2)
      end
    end

    describe ".by_grade" do
      it "returns students by grade A" do
        expect(Student.by_grade("A")).to include(student1)
      end

      it "returns students by grade C" do
        expect(Student.by_grade("C")).to include(student2)
      end

      it "returns students by grade F" do
        expect(Student.by_grade("F")).to include(student3)
      end
    end
  end

  describe "#result" do
    it "returns Pass when marks are >= 35" do
      student = build(:student, marks: 35)
      expect(student.result).to eq("Pass")
    end

    it "returns Fail when marks are < 35" do
      student = build(:student, marks: 34)
      expect(student.result).to eq("Fail")
    end
  end
end
