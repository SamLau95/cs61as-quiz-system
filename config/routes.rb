Cs61asQuizzes::Application.routes.draw do

  devise_for :users
  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  scope '/staff' do
    get '', to: 'staff_dashboard#index', as: :staff_dashboard
  end

  resources :students
  scope '/student' do
    get '', to: 'student_dashboard#index', as: :student_dashboard
  end

  resources :quizzes, except: :show
  scope '/quizzes' do
    get '/:lesson/request',  to: 'quizzes#make_request',
                             as: :make_quiz_request
    post '/:lesson/request', to: 'quizzes#process_request',
                             as: :process_quiz_request
    get '/:id/take',         to: 'quizzes#take',   as: :take_quiz
    post '/:id/submit',      to: 'quizzes#submit', as: :submit_quiz
  end

  resources :submissions
  scope '/submissions' do
    post '/save', to: 'quizzes#save_submission', as: :save_submission
  end

end
