class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :full_name, null: false
      t.string :job_title, null: false
      t.string :country, null: false
      t.decimal :salary, precision: 12, scale: 2, null: false
      t.string :department, null: false

      t.timestamps
    end

    add_index :employees, :country
    add_index :employees, :job_title
    add_index :employees, :department
  end
end
