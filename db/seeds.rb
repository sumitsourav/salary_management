# Read name files
first_names_file = Rails.root.join('first_names.txt')
last_names_file = Rails.root.join('last_names.txt')

unless File.exist?(first_names_file) && File.exist?(last_names_file)
  puts "Error: first_names.txt and last_names.txt not found in project root"
  exit 1
end

first_names = File.read(first_names_file).split("\n").map(&:strip).reject(&:empty?)
last_names = File.read(last_names_file).split("\n").map(&:strip).reject(&:empty?)

countries = ["USA", "UK", "India", "Canada", "Germany", "France", "Japan", "Australia"]
departments = ["Engineering", "Product", "HR", "Sales", "Operations", "Finance", "Marketing"]
job_titles = ["Software Engineer", "Product Manager", "Designer", "Data Analyst", "HR Manager", "Sales Executive", "DevOps Engineer", "QA Engineer"]

# Salary ranges per job title and country (base range, then adjusted per country)
salary_ranges = {
  "Software Engineer" => { base: [80000, 200000], multipliers: { "USA" => 1.2, "UK" => 1.0, "Canada" => 1.15, "Germany" => 0.95, "France" => 0.9, "Japan" => 1.05, "Australia" => 1.1, "India" => 0.35 } },
  "Product Manager" => { base: [90000, 180000], multipliers: { "USA" => 1.2, "UK" => 1.0, "Canada" => 1.1, "Germany" => 0.95, "France" => 0.9, "Japan" => 1.0, "Australia" => 1.1, "India" => 0.4 } },
  "Designer" => { base: [70000, 150000], multipliers: { "USA" => 1.2, "UK" => 1.0, "Canada" => 1.1, "Germany" => 0.95, "France" => 0.85, "Japan" => 0.95, "Australia" => 1.05, "India" => 0.35 } },
  "Data Analyst" => { base: [60000, 140000], multipliers: { "USA" => 1.2, "UK" => 1.0, "Canada" => 1.1, "Germany" => 0.95, "France" => 0.85, "Japan" => 1.0, "Australia" => 1.05, "India" => 0.4 } },
  "HR Manager" => { base: [50000, 120000], multipliers: { "USA" => 1.2, "UK" => 1.0, "Canada" => 1.1, "Germany" => 1.0, "France" => 0.9, "Japan" => 0.95, "Australia" => 1.05, "India" => 0.35 } },
  "Sales Executive" => { base: [40000, 150000], multipliers: { "USA" => 1.2, "UK" => 1.0, "Canada" => 1.1, "Germany" => 0.95, "France" => 0.85, "Japan" => 0.9, "Australia" => 1.05, "India" => 0.3 } },
  "DevOps Engineer" => { base: [80000, 180000], multipliers: { "USA" => 1.2, "UK" => 1.0, "Canada" => 1.15, "Germany" => 0.95, "France" => 0.9, "Japan" => 1.05, "Australia" => 1.1, "India" => 0.35 } },
  "QA Engineer" => { base: [60000, 140000], multipliers: { "USA" => 1.2, "UK" => 1.0, "Canada" => 1.1, "Germany" => 0.95, "France" => 0.85, "Japan" => 0.95, "Australia" => 1.05, "India" => 0.35 } }
}

puts "Starting to seed 10,000 employees..."
start_time = Time.now

employees = []
10000.times do |i|
  country = countries.sample
  job_title = job_titles.sample
  department = departments.sample

  range_config = salary_ranges[job_title]
  base_min, base_max = range_config[:base]
  multiplier = range_config[:multipliers][country]
  min_salary = (base_min * multiplier).round(2)
  max_salary = (base_max * multiplier).round(2)
  salary = rand(min_salary..max_salary).round(2)

  employees << {
    full_name: "#{first_names.sample} #{last_names.sample}",
    job_title: job_title,
    country: country,
    salary: salary,
    department: department,
    created_at: Time.now,
    updated_at: Time.now
  }

  if (i + 1) % 500 == 0
    Employee.insert_all(employees)
    puts "Inserted #{i + 1} employees..."
    employees = []
  end
end

Employee.insert_all(employees) if employees.any?

end_time = Time.now
duration = (end_time - start_time).round(2)

puts "✓ Successfully seeded 10,000 employees in #{duration} seconds"
puts "Total employees in database: #{Employee.count}"
