# Prepare vanilla decidim installation
if Gem.loaded_specs.has_key?('voca')
    ::Decidim::Voca.configure do |config|
        config.on(:before_setup_db) do
            system("bundle exec rails decidim_decidim_awesome:install:migrations")
            system("bundle exec rails decidim_term_customizer:install:migrations")
        end

        config.on(:before_compile_assets) do
            system("bundle exec rails decidim_decidim_awesome:webpacker:install")
        end
    end
end
