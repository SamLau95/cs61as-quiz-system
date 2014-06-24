Cs61asQuizzes::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'students/registrations' }
  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  resources :users, only: [:edit, :update]

  scope '/staff' do
    get '', to: 'staff_dashboard#index', as: :staff_dashboard
    post '/download', to: 'staff_dashboard#download', as: :download_grades
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
  end

  resources :students
  scope '/student' do
    get '', to: 'student_dashboard#index', as: :student_dashboard
    get '/view_quiz/:id', to: 'students#view', as: :view_quiz
    put '/view_quiz/:id/finish', to: 'students#finish', as: :finish_grading
    get '/grade_quiz/:id', to: 'students#grade', as: :grade_quiz
  end

  resources :quizzes
  get '/take_quiz', to: 'quizzes#take', as: :take_quiz
  scope '/quizzes' do
    post '/request', to: 'quizzes#make_request',
                     as: :make_quiz_request
    post '/:id/submit', to: 'quizzes#submit', as: :submit_quiz
    delete '/:id/delete', to: 'quizzes#delete_question', as: :delete_rlt
    get '/stats/:id', to: 'quizzes#stats', as: :check_quiz
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

  resources :taken_quizzes, only: [:update]

  resources :grades

  resources :regrades, except: [:new, :edit, :update]
  scope '/regrades' do
    post '/:id/change', to: 'regrades#change_status', as: :change_grade_status
  end
end
