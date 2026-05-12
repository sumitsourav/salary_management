require 'rails_helper'

RSpec.describe "Api::V1::Insights", type: :request do
  describe "GET /api/v1/insights/salary_by_country" do
    before do
      create(:employee, country: "USA", salary: 50000)
      create(:employee, country: "USA", salary: 100000)
      create(:employee, country: "India", salary: 30000)
    end

    it "returns http success" do
      get "/api/v1/insights/salary_by_country"
      expect(response).to have_http_status(:success)
    end

    it "returns min/max/avg salary and count per country" do
      get "/api/v1/insights/salary_by_country"
      json = JSON.parse(response.body)
      usa = json.find { |r| r["country"] == "USA" }
      expect(usa["min_salary"]).to eq(50000.0)
      expect(usa["max_salary"]).to eq(100000.0)
      expect(usa["avg_salary"]).to eq(75000.0)
      expect(usa["employee_count"]).to eq(2)
    end
  end

  describe "GET /api/v1/insights/salary_by_job_title" do
    before do
      create(:employee, country: "USA", job_title: "Engineer", salary: 80000)
      create(:employee, country: "USA", job_title: "Engineer", salary: 120000)
      create(:employee, country: "USA", job_title: "Designer", salary: 90000)
      create(:employee, country: "India", job_title: "Engineer", salary: 40000)
    end

    it "returns avg salary per job title filtered by country" do
      get "/api/v1/insights/salary_by_job_title", params: { country: "USA" }
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      engineer = json.find { |r| r["job_title"] == "Engineer" }
      expect(engineer["avg_salary"]).to eq(100000.0)
      expect(engineer["employee_count"]).to eq(2)
    end

    it "returns data for all countries when no filter is given" do
      get "/api/v1/insights/salary_by_job_title"
      json = JSON.parse(response.body)
      engineer = json.find { |r| r["job_title"] == "Engineer" }
      expect(engineer["employee_count"]).to eq(3)
    end
  end

  describe "GET /api/v1/insights/top_earners" do
    before do
      create(:employee, full_name: "Alice", country: "USA", salary: 200000)
      create(:employee, full_name: "Bob",   country: "USA", salary: 150000)
      create(:employee, full_name: "Carol", country: "USA", salary: 100000)
      create(:employee, full_name: "Dan",   country: "India", salary: 90000)
    end

    it "returns top earners ordered by salary desc" do
      get "/api/v1/insights/top_earners", params: { limit: 2 }
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
      expect(json.first["full_name"]).to eq("Alice")
      expect(json.first["salary"]).to eq(200000.0)
    end

    it "filters top earners by country" do
      get "/api/v1/insights/top_earners", params: { country: "India", limit: 5 }
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first["full_name"]).to eq("Dan")
    end

    it "defaults to limit of 10" do
      get "/api/v1/insights/top_earners"
      json = JSON.parse(response.body)
      expect(json.length).to be <= 10
    end
  end
end
