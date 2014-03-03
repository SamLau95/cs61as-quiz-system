Cs61asQuizzes::Application.routes.draw do

  get "quizzes/show"
  get "quizzes/take"
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

  resources :quizzes, except: :show
  scope '/quizzes' do
    get '/:id/take', to: 'quizzes#take', as: :take_quiz
    post '/:id/submit', to: 'quizzes#submit', as: :submit_quiz
  end

end
