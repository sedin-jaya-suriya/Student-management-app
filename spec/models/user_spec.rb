require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
  end

  describe "associations" do
    it { should have_many(:students).with_foreign_key(:teacher_id).dependent(:destroy) }
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values(admin: "admin", teacher: "teacher").backed_by_column_of_type(:string) }
  end
end
