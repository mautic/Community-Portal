Decidim::Sitemaps.configure do |config|
  config.users = { enabled: false, changefreq: "daily", priority: 0.5 }
  # @see defaults https://git.fpfis.tech.ec.europa.eu/future-of-europe/digit-cofe-libraries/digit-cofe-sitemap/-/blob/master/lib/decidim/sitemaps.rb?ref_type=heads
end