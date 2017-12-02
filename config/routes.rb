Rails.application.routes.draw do
  
  
  
  get 'users/index'

  #get '/rides/:id/calendar' => 'frontend/rides#calendar'
  #get '/rides/:id/get_rides' => 'frontend/rides#get_rides'
  
  scope module: 'frontend' do
    # resources :riders do
    #   get 'my_rider_profile', :on => :collection
    # end
    # resources :owners do
    #   get 'my_owner_profile', :on => :collection
    # end
    # resources :notifications
    # resources :calendars, :only => [:index ]
    # resources :rides do
    #   get 'search_index', :on => :collection 
    #   get 'get_rides', :on => :collection
    #   get 'my_ride_offers', :on => :collection
    #    member do
    #     get 'show_ride'
    #     get 'calendar'
    #   end
    #   resources :schedules do
    #     get 'home', :on => :collection
    #     patch 'resize', on: :member
    #     patch 'move', on: :member
    #   end
    # end
    resources :notifications
    resources :products, :only => [:index]
  end


  namespace :frontend do
    get 'home/index'
    #get 'reservations/index'
    #post 'reservations/create'
  end

  #devise_for :users
  #devise_for :users#, controllers: { sessions: 'users/sessions', 
                                #    registrations: 'users/registrations' }

  devise_for :users, controllers: { registrations: "users/registrations" }                                

  
  resources :users do
      get 'users', :on => :collection 
  end
  devise_scope :user do
    get '/registrations/instruction' => 'users/registrations#instruction'
  end


  apipie
  
  namespace :api do
      namespace :v1 do
        resources :products
        resources :categories
      end
  end
  
  root 'frontend/home#index'

  get 'backend/welcome/index'

  

  scope '/admin', :module => 'backend' do
      resources :riders
      resources :owners
      resources :rides
      resources :sizes
      resources :tax_rates
      resources :brands
      resources :brands
      resources :brands
      scope "suppliers/:supplier_id" do
        resources :registration_steps
      end

      resources :suppliers do
        resources :contacts
        resources :addresses
        resources :finances
      end
      
      resources :stock_levels, :only => [:index, :create, :destroy]
        
      get 'dashboard' => 'dashboard#index'

      resources :products do
        post 'park_images', :on => :collection
        resources :variants
        resources :images, :only => [:create, :destroy] do
          collection do
            get 'remove_all'
          end
        end
      end

      resources :categories do
        resources :subcategories
      end
    end
  #end
      

  scope module: 'common' do
    resources :images do 
      post 'park_images', :on => :collection
      post 'removed_parked_image', :on => :collection
    end
  end
  mount FullcalendarEngine::Engine => "/fullcalendar_engine"
  # The priority is based upon order of creation: first created -> highest priority.
  #root 'welcome#index'
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
