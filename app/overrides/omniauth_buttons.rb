# frozen_string_literal: true

Deface::Override.new(virtual_path: "decidim/devise/shared/_omniauth_buttons",
                     name: "omniauth_login_button",
                     replace: 'span:contains("normalize_provider_name(provider).titleize")',
                     text: <<~ERB
                       <span><%= t("devise.shared.omniauth_\#{normalize_provider_name(provider).underscore}_button") %></span>
                     ERB
                    )
