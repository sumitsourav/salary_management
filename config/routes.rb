Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :employees

      namespace :insights do
        get :salary_by_country
        get :salary_by_job_title
        get :top_earners
      end
    end
  end
end
