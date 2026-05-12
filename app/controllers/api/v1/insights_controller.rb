class Api::V1::InsightsController < ApplicationController
  def salary_by_country
    insights = Employee
      .group(:country)
      .select(:country, "MIN(salary) as min_salary", "MAX(salary) as max_salary", "AVG(salary) as avg_salary", "COUNT(*) as employee_count")
      .map { |row| {
        country: row.country,
        min_salary: row.min_salary.to_f.round(2),
        max_salary: row.max_salary.to_f.round(2),
        avg_salary: row.avg_salary.to_f.round(2),
        employee_count: row.employee_count
      }}
    render json: insights
  end

  def salary_by_job_title
    country = params[:country]
    query = Employee.group(:job_title)
    query = query.where(country: country) if country.present?

    insights = query
      .select(:job_title, "AVG(salary) as avg_salary", "COUNT(*) as employee_count")
      .map { |row| {
        job_title: row.job_title,
        avg_salary: row.avg_salary.to_f.round(2),
        employee_count: row.employee_count
      }}
    render json: insights
  end

  def top_earners
    country = params[:country]
    limit = params[:limit] || 10
    query = Employee.order(salary: :desc)
    query = query.where(country: country) if country.present?

    earners = query.limit(limit).map { |emp| {
      id: emp.id,
      full_name: emp.full_name,
      salary: emp.salary.to_f.round(2),
      job_title: emp.job_title,
      country: emp.country,
      department: emp.department
    }}
    render json: earners
  end
end
