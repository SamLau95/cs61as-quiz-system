Cs61asQuizzes::Application.routes.draw do
  devise_for :users
  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  resources :users, only: [:edit, :update]

  scope '/staff' do
    get '', to: 'staff_dashboard#index', as: :staff_dashboard
    post '/download_grades', to: 'staff_dashboard#download', as: :download_grades
    get '/bank/:id', to: 'staff_dashboard#bank', as: :question_bank
    post '/add/:id', to: 'staff_dashboard#add', as: :add_question
    get '/questions', to: 'staff_dashboard#questions', as: :question_dashboard
    get '/requests', to: 'staff_dashboard#requests', as: :requests_dashboard
    get '/students', to: 'staff_dashboard#students', as: :students_dashboard
    get '/grading', to: 'staff_dashboard#grading', as: :grading_dashboard
    get '/import_students', to: 'staff_dashboard#import_students_form',
                            as: :import_students_form
    post '/import_students', to: 'staff_dashboard#import_students',
                             as: :import_students
    get '/download_passwords', to: 'staff_dashboard#download_initial_passwords', as: :download_pw
    get '/download_questions', to: 'staff_dashboard#download_questions', as: :download_questions
  end

  resources :students
  scope '/student' do
    get '', to: 'student_dashboard#index', as: :student_dashboard
    get '/view_quiz/:id', to: 'students#view', as: :view_quiz
    put '/view_quiz/:id/finish', to: 'students#finish', as: :finish_grading
    get '/grade_quiz/:id', to: 'students#grade', as: :grade_quiz
  end

  resources :quizzes do
    collection do
      get :take
    end
  end
  get '/take_quiz', to: 'quizzes#take', as: :take_quiz
  scope '/quizzes' do
    post '/request', to: 'quizzes#make_request',
                     as: :make_quiz_request
    post '/:id/submit', to: 'quizzes#submit', as: :submit_quiz
    delete '/:id/delete', to: 'quizzes#delete_question', as: :delete_rlt
    get '/stats/:id', to: 'quizzes#stats', as: :check_quiz
  end

  resources :submissions

  resources :questions

  resources :quiz_requests, only: :destroy do
    member do
      post :approve
    end
  end

  resources :quiz_locks, only: [:lock, :unlock] do
    member do
      post :lock
      patch :unlock
    end
  end

  resources :taken_quizzes, only: [:update]

  resources :grades

  resources :regrades, except: [:new, :edit, :update]
end
