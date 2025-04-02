# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do

  mount Decidim::Core::Engine => "/"
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
