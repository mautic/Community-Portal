# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", ENV.fetch("DECIDIM_VERSION", "0.27.3")
# gem "decidim-conferences", ENV.fetch("DECIDIM_VERSION", "0.27.3")
# gem "decidim-consultations", ENV.fetch("DECIDIM_VERSION", "0.27.3")
# gem "decidim-elections", ENV.fetch("DECIDIM_VERSION", "0.27.3")
# gem "decidim-initiatives", ENV.fetch("DECIDIM_VERSION", "0.27.3")
# gem "decidim-templates", ENV.fetch("DECIDIM_VERSION", "0.27.3")

gem "bootsnap", "~> 1.3"

gem "puma", ">= 5.0.0"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer", branch: "master"
gem "decidim-only_forms", git: "https://git.octree.ch/decidim/decidim-module-only_forms", branch: "release/0.27-stable"
gem "decidim-decidim_awesome", ">= 0.9"

gem "faker", "~> 2.14"
gem 'omniauth_openid_connect'

gem "wicked_pdf", "~> 2.1"
gem "dalli", "~> 3.2"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "brakeman"
  gem "decidim-dev", ENV.fetch("DECIDIM_VERSION", "0.27.3")
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.2"
end

group :production do
  gem 'sidekiq'
end
