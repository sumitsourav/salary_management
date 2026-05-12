require 'rails_helper'

RSpec.describe "Api::V1::Employees", type: :request do
  describe "GET /api/v1/employees" do
    before { create_list(:employee, 3) }

    it "returns http success" do
      get "/api/v1/employees"
      expect(response).to have_http_status(:success)
    end

    it "returns paginated employees" do
      get "/api/v1/employees"
      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(3)
      expect(json["pagination"]).to include("current_page", "per_page", "total_count", "total_pages")
    end

    it "respects per_page parameter" do
      get "/api/v1/employees", params: { per_page: 2 }
      json = JSON.parse(response.body)
      expect(json["data"].length).to eq(2)
    end
  end

  describe "GET /api/v1/employees/:id" do
    let(:employee) { create(:employee) }

    it "returns the employee" do
      get "/api/v1/employees/#{employee.id}"
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(employee.id)
      expect(json["full_name"]).to eq(employee.full_name)
    end
  end

  describe "POST /api/v1/employees" do
    let(:valid_attributes) do
      {
        employee: {
          full_name: "John Doe",
          job_title: "Designer",
          country: "USA",
          salary: 80000,
          department: "Product"
        }
      }
    end

    it "creates a new employee" do
      expect {
        post "/api/v1/employees", params: valid_attributes
      }.to change(Employee, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns errors with invalid attributes" do
      post "/api/v1/employees", params: { employee: { full_name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to be_present
    end
  end

  describe "PUT /api/v1/employees/:id" do
    let(:employee) { create(:employee) }

    it "updates the employee" do
      put "/api/v1/employees/#{employee.id}", params: { employee: { salary: 99999 } }
      expect(response).to have_http_status(:success)
      expect(employee.reload.salary).to eq(99999)
    end

    it "returns errors with invalid attributes" do
      put "/api/v1/employees/#{employee.id}", params: { employee: { full_name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /api/v1/employees/:id" do
    let!(:employee) { create(:employee) }

    it "deletes the employee" do
      expect {
        delete "/api/v1/employees/#{employee.id}"
      }.to change(Employee, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
