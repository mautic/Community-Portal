# frozen_string_literal: true
# This migration comes from decidim_spam_signal (originally 20221010141918)

class UnifiedConfig < ActiveRecord::Migration[5.2]
  def change
    drop_table :spam_signal_config_tables
    create_table :spam_signal_config_tables do |t|
      t.integer :decidim_organization_id,
                foreign_key: true,
                index: { name: "index_decidim_spam_signal_on_decidim_organization_id" }
      t.jsonb :comment_settings
      t.jsonb :profile_settings
      t.timestamps
    end
  end
end
