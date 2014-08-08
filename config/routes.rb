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

  get '/student_dashboard', to: 'student_dashboard#index'
  resources :students do
    scope module: 'students' do
      resources :quizzes, only: :show do
        put :finish_grading
      end
    end
  end

  resources :quizzes do
    resource :relationships, only: :destroy

    member do
      post :submit
      get :stats
    end

    collection do
      get :take
      post :make_request
    end
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
