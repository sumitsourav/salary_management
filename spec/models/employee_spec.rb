require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe "validations" do
    it "is valid with all required attributes" do
      employee = build(:employee)
      expect(employee).to be_valid
    end

    it "is invalid without a full_name" do
      employee = build(:employee, full_name: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:full_name]).to include("can't be blank")
    end

    it "is invalid without a job_title" do
      employee = build(:employee, job_title: nil)
      expect(employee).not_to be_valid
    end

    it "is invalid without a country" do
      employee = build(:employee, country: nil)
      expect(employee).not_to be_valid
    end

    it "is invalid without a department" do
      employee = build(:employee, department: nil)
      expect(employee).not_to be_valid
    end

    it "is invalid without a salary" do
      employee = build(:employee, salary: nil)
      expect(employee).not_to be_valid
    end

    it "is invalid with a zero or negative salary" do
      expect(build(:employee, salary: 0)).not_to be_valid
      expect(build(:employee, salary: -100)).not_to be_valid
    end

    it "is valid with a positive salary" do
      expect(build(:employee, salary: 1)).to be_valid
    end
  end
end
