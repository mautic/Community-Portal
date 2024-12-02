# frozen_string_literal: true
def custom_provider_setup(provider, config_mapping = {})
  lambda do |env|
    request = Rack::Request.new(env)
    organization = Decidim::Organization.find_by(host: request.host)
    provider_config = organization.enabled_omniauth_providers[provider]
    config_mapping.each do |option_key, config_key|
      if "#{option_key}".include?("__")
        (keyParent, key) = "#{option_key}".split('__');
        env["omniauth.strategy"].options[keyParent.to_sym] = {} unless env["omniauth.strategy"].options[keyParent.to_sym].present?
        env["omniauth.strategy"].options[keyParent.to_sym][key.to_sym] = provider_config[config_key] if provider_config[config_key].present?
      else 
        env["omniauth.strategy"].options[option_key] = provider_config[config_key]
      end
    end
    env["omniauth.strategy"]
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  omniauth_config = Rails.application.secrets[:omniauth]
  if omniauth_config[:openid_connect].present?
    provider(
      :openid_connect,
      setup: custom_provider_setup(
          :openid_connect, 
          name: :name,
          response_type: :response_type,
          discovery: false,
          scope: :scope,
          uid_field: :uid_field,
          display: :display,
          prompt: :prompt,
          issuer: :issuer,	
          post_logout_redirect_uri: :post_logout_redirect_uri,
          client_options__port: :client_options__port,
          client_options__scheme: :client_options__scheme,
          client_options__host: :client_options__host,
          client_options__authorization_endpoint: :client_options__authorization_endpoint,
          client_options__token_endpoint: :client_options__token_endpoint,
          client_options__userinfo_endpoint: :client_options__userinfo_endpoint,
          client_options__jwks_uri: :client_options__jwks_uri,
          client_options__end_session_endpoint: :client_options__end_session_endpoint,
          client_options__identifier: :client_options__identifier,
          client_options__secret: :client_options__secret,
          client_options__redirect_uri: :client_options__redirect_uri
      )
    )
  end
end
