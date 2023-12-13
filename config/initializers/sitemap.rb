Decidim::Sitemaps.configure do |config|
    config.users = { enabled: false, changefreq: "daily", priority: 0.5 }
    config.proposals = { enabled: true, changefreq: "daily", priority: 0.5, scopes: [:published] }
  end