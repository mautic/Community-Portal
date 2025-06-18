module Decidim
  module Mautic
      module OverridesMeetingsController
          extend ActiveSupport::Concern

          included do
            # Alias the original mail method
            alias_method :decidim_mautic_original_meeting, :meeting

            private 
            def meeting
              return nil if !params[:id] || params[:id].to_i <= 0
              decidim_mautic_original_meeting
            end
 
          end
      end
  end
end
Rails.application.configure do 
  config.to_prepare do
    Decidim::Meetings::Admin::MeetingsController.include(Decidim::Mautic::OverridesMeetingsController)
  end
end