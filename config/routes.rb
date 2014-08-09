Cs61asQuizzes::Application.routes.draw do
  devise_for :users
  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  resources :users, only: [:edit, :update]

  scope module: 'staffs' do
    get '/staff_dashboard', to: 'dashboard#index', as: :staff_dashboard

    resources :grades do
      collection do
        post :download
      end
    end

    resources :questions do
      member do
        post :add
      end

      collection do
        get :bank
      end
    end

    resources :quiz_requests, only: [:index, :destroy] do
      member do
        post :approve
      end
    end

    resources :students, only: [:index, :show] do
      scope module: 'students' do
        resources :quizzes, only: :show do
          put :finish_grading
        end
      end
    end

    get '/students', to: 'dashboard#students', as: :students_dashboard
    get '/grading', to: 'dashboard#grading', as: :grading_dashboard
    get '/import_students', to: 'dashboard#import_students_form',
                            as: :import_students_form
    post '/import_students', to: 'dashboard#import_students',
                             as: :import_students
    get '/download_passwords', to: 'dashboard#download_initial_passwords', as: :download_pw
    get '/download_questions', to: 'dashboard#download_questions', as: :download_questions
  end

  get '/student_dashboard', to: 'students/dashboard#index', as: :student_dashboard


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

  resources :quiz_locks, only: [:lock, :unlock] do
    member do
      post :lock
      patch :unlock
    end
  end

  resources :taken_quizzes, only: [:update]

  resources :regrades, except: [:new, :edit, :update]
end
