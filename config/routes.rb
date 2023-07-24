# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :academics

  namespace :academic do
    mount EpiCas::Engine, at: '/'

    resources :menu, controller: :menu, only: :index
    resources :folders
    resources :resources, only: :index
    get 'shared', to: 'resources#shared'
    resources :quiz_sessions
    post 'pause', to: 'quiz_sessions#pause'
    post 'next', to: 'quiz_sessions#next'
    resources :quizzes do
      resources :sharing, controller: 'quizzes/sharing'
      resources :questions, controller: 'quizzes/questions' do
        post :add_answer, on: :collection
        post :destroy_answer, on: :collection
        post :increase_position, on: :collection
        post :decrease_position, on: :collection
      end
      get 'preview', to: 'quizzes#preview'
    end
  end

  resources :events, only: [:index]
  resources :player_sessions
  resources :player_answers, only: [:create]
  post 'player_join', to: 'player_sessions#player_join'

  get 'accessibility', to: 'pages#accessibility'
  get 'help', to: 'pages#help'

  root 'player_sessions#join'
end
