Cs61asQuizzes::Application.routes.draw do

  devise_for :users
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  scope '/staff' do
    get '', to: 'staff_dashboard#index', as: :staff_dashboard
  end

  scope '/student' do
    get '', to: 'student_dashboard#index', as: :student_dashboard
  end

end
