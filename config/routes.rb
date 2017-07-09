Rails.application.routes.draw do
  devise_for :parents, controllers: { sessions: 'authentication/parent_sessions' }
  devise_for :teachers, controllers: { sessions: 'authentication/teacher_sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  concern :public_routes do
    get '/', to: 'public/home#index'

    # put other public pages here
  end 

  authenticated :teacher do
    namespace :teacher do
      get '/', to: 'home#index', as: 'home'

      resources :semesters

      resources :special_events,              except: :index

      resources :courses,                     except: :index

      resources :sections#,                    except: :index
      resources :sections, as: :event_groups, except: :index

      resources :events, only: [ :new, :create, :show, :edit, :update, :destroy ]
    end
  end

  authenticated :parent do
    namespace :parent do
      get '/', to: 'home#index', as: 'home'

      resources :students do
        get 'catalog'

        resources :ballots, except: [:edit, :show, :index]
      end

      resources :events, only: [ :index, :show ]
    end
  end

  unauthenticated concern: :public_routes do
    root to: 'public/home#index'
  end
end
