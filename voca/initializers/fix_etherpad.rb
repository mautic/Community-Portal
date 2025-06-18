module Decidim
  module Mautic
    module OverridesEtherpad
      extend ActiveSupport::Concern
      
      included do
        alias_method :decidim_etherpad_original_resolve, :resolve
        def resolve(path, params = {})
        decidim_etherpad_original_resolve(path, params)
        rescue => e
          Rails.logger.error("Error getting pad data: #{e.message}")
          {readOnlyID: nil, text: nil}
        end
      end
    end
  end
end

Rails.application.configure do 
  config.to_prepare do
    Decidim::Etherpad::Pad.include(Decidim::Mautic::OverridesEtherpad)
  end
end