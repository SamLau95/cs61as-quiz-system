Cs61asQuizzes::Application.routes.draw do

  devise_for :users
  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  resources :users, only: [:edit, :update]

  scope '/staff' do
    get '', to: 'staff_dashboard#index', as: :staff_dashboard
    get '/bank/:id', to: 'staff_dashboard#bank', as: :question_bank
    post '/add/:id', to: 'staff_dashboard#add', as: :add_question
  end

  resources :students
  scope '/student' do
    get '', to: 'student_dashboard#index', as: :student_dashboard
    get '/view_quiz/:id', to: 'students#view', as: :view_quiz
    get '/grade_quiz/:id', to: 'students#grade', as: :grade_quiz
  end

  resources :quizzes
  get '/take_quiz', to: 'quizzes#take', as: :take_quiz
  scope '/quizzes' do
    post '/:lesson/request', to: 'quizzes#make_request',
                             as: :make_quiz_request
    post '/:id/submit', to: 'quizzes#submit', as: :submit_quiz
    delete '/:id/delete', to: 'quizzes#delete_question', as: :delete_rlt
  end

  resources :submissions
  scope '/submissions' do
    post '/save', to: 'quizzes#save_submission', as: :save_submission
  end

  resources :questions

  scope '/quiz_requests' do
    post '/:id/approve', to: 'quiz_requests#approve', as: :approve_request
    delete '/:id/',      to: 'quiz_requests#cancel',  as: :cancel_request
  end

  scope '/quiz_locks' do
    post '/:id/lock',    to: 'quiz_locks#lock',   as: :lock_student
    patch '/:id/unlock', to: 'quiz_locks#unlock', as: :unlock_student
  end

  resources :grades

  resources :regrades, except: [:new, :edit, :update]
  scope '/regrades' do
    post '/:id/change', to: 'regrades#change_status', as: :change_grade_status
  end
end
