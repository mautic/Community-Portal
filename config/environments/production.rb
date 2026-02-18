require "active_support/logger"
require "rack/attack"

Rails.application.configure do
  
  def env_enabled?(env_name, default_value = "disabled")
    ["true", "1", "enabled"].include? ENV.fetch(env_name, default_value)
  end
  
  def env_present?(env_name)
    value = ENV.fetch(env_name, "").to_s.strip
    !value.blank?
  end
  
  # Disable Rack Attack, let Nginx handle this. 
  Rack::Attack.enabled = false

  # Settings specified here will take precedence over those in config/application.rb.
  config.after_initialize do 
    if ActiveRecord::Base.connected?
      if ::Decidim::Organization.count > 0 
        ::Decidim::Organization.all.pluck(:host).each do |host|
          Rails.application.config.hosts << host
        end
      else
        Rails.application.config.hosts = /.*/
      end
    end
  end

  config.deface.enabled = env_enabled?(ENV.fetch('DEFACE_ENABLED', "disabled"))

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = env_enabled?("RAILS_SERVE_STATIC_FILES")

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = ENV.fetch("STORAGE_PROVIDER", "local").to_sym

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = env_enabled?("DECIDIM_FORCE_SSL")

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = ENV.fetch("DECIDIM_LOG_LEVEL", "warn").to_sym

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  if env_present?("CACHE_ADAPTER")
    if ENV.fetch("CACHE_ADAPTER", "") == "memcached"
      # See https://github.com/petergoldstein/dalli/wiki/Using-Dalli-with-Rails#cache-store
      servers = ENV.fetch("MEMCACHE_SERVERS", "localhost:11211").split(",").map(&:strip)
      config.cache_store = :mem_cache_store, *servers
    end
  end
  # Set session store activerecord-session_store keys if loaded
  if Gem.loaded_specs.has_key?('activerecord-session_store')
    config.after_initialize do
      Rails.application.config.session_store :active_record_store, :key => '_voca_session'
    end
  end
  
  if env_present?("QUEUE_ADAPTER")
    # Use a real queuing backend for Active Job (and separate queues per environment)
    if ENV.fetch("QUEUE_ADAPTER", "default") == "sidekiq" && ENV["REDIS_URL"].present?
      config.active_job.queue_adapter = :sidekiq
    end

    if ENV.fetch("QUEUE_ADAPTER", "default") == "good_job"
      config.active_job.queue_adapter = :good_job
    end
  end

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true
  config.i18n.raise_on_missing_translations = false


  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = env_enabled?("SMTP_RAISE_DELIVERY_ERRORS", "enabled")

  config.action_mailer.smtp_settings = {}

  if env_present?("SMTP_ADDRESS")
    config.action_mailer.smtp_settings[:address] = ENV.fetch("SMTP_ADDRESS", "")
  end

  if env_present?("SMTP_PORT")
    config.action_mailer.smtp_settings[:port] = ENV.fetch("SMTP_PORT", "587").to_i
  end
  
  if env_present?("SMTP_DOMAIN")
    config.action_mailer.smtp_settings[:domain] = ENV.fetch("SMTP_DOMAIN", "")
  end

  if env_present?("SMTP_SSL")
    config.action_mailer.smtp_settings[:ssl] = env_enabled?("SMTP_SSL", "disabled")
  end

  if env_present?("SMTP_TLS")
    config.action_mailer.smtp_settings[:tls] = env_enabled?("SMTP_TLS", "disabled")
  end

  if env_present?("SMTP_STARTTLS_AUTO")
    config.action_mailer.smtp_settings[:enable_starttls_auto] = env_enabled?("SMTP_STARTTLS_AUTO", "disabled")
  end

  if env_present?("SMTP_VERIFY_MODE")
    verify_mode = ENV.fetch("SMTP_VERIFY_MODE", "none") == "peer" ? "peer" : "none"
    config.action_mailer.smtp_settings[:openssl_verify_mode] = verify_mode
  end

  if env_present?("SMTP_OPEN_TIMEOUT")
    config.action_mailer.smtp_settings[:open_timeout] = ENV.fetch("SMTP_OPEN_TIMEOUT", "6000").to_i
  end
  
  if env_present?("SMTP_READ_TIMEOUT")
    config.action_mailer.smtp_settings[:read_timeout] = ENV.fetch("SMTP_READ_TIMEOUT", "6000").to_i
  end

  if env_present?("SMTP_AUTHENTICATION")
    authentication_type = ENV.fetch("SMTP_AUTHENTICATION", "plain")
    case authentication_type
    when "plain", "login", "cram_md5"
      config.action_mailer.smtp_settings[:authentication] = authentication_type
      config.action_mailer.smtp_settings[:user_name] = ENV.fetch("SMTP_USERNAME", "") if env_present?("SMTP_USERNAME")
      config.action_mailer.smtp_settings[:password] = ENV.fetch("SMTP_PASSWORD", "") if env_present?("SMTP_PASSWORD")
    else
      raise "Invalid SMTP authentication type: #{authentication_type}. Valid options are: plain, login, cram_md5."
    end
  end

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')
  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.logger = ActiveSupport::Logger.new(STDOUT)

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
