Rails.application.routes.draw do

  scope '/compliance' do

    resources :arf_reports, :only => [:index, :show, :destroy] do
      member do
        match 'parse', :to => 'arf_reports#parse'
      end
      collection do
        get 'auto_complete_search'
      end
    end

    match 'dashboard', :to => 'compliance_dashboard#index', :as => "compliance_dashboard"

    resources :policies, :only => [:index, :new, :show, :create, :edit, :update, :destroy] do
      member do
        match 'parse', :to => 'policies#parse'
        match 'dashboard', :to => 'policy_dashboard#index', :as => 'policy_dashboard'
      end
      collection do
        get 'auto_complete_search'
        post 'scap_content_selected'
        get 'select_multiple_hosts'
        post 'update_multiple_hosts'
        get 'disassociate_multiple_hosts'
        post 'remove_policy_from_multiple_hosts'
      end
    end

    resources :scap_contents do
      collection do
        get 'auto_complete_search'
      end
    end

    resources :hosts, :only => [:show], :as => :compliance_hosts, :controller => :compliance_hosts
  end

  namespace :api do
    scope "(:apiv)", :module => :v2, :defaults => {:apiv => 'v2'},
          :apiv => /v1|v2/, :constraints => ApiConstraints.new(:version => 2) do
      namespace :compliance do
        resources :scap_contents, :except => [:new, :edit]
        resources :policies, :except => [:new, :edit] do
          member do
            get 'content'
          end
        end
        resources :arf_reports, :only => [:index, :show, :destroy]
        post 'arf_reports/:cname/:policy_id/:date', \
              :constraints => { :cname => /[^\/]+/ }, :to => 'arf_reports#create'
      end
    end
  end
end
