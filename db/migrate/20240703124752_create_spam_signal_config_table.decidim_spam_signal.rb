# frozen_string_literal: true
# This migration comes from decidim_spam_signal (originally 20220728004242)

class CreateSpamSignalConfigTable < ActiveRecord::Migration[5.2]
  def change
    create_table :spam_signal_config_tables do |t|
      t.integer :decidim_organization_id,
                foreign_key: true,
                index: { name: "index_decidim_spam_signal_on_decidim_organization_id" }
      t.string :profile_scan
      t.string :comment_scan

      t.string :profile_obvious_cop
      t.string :profile_suspicious_cop
      t.string :comment_obvious_cop
      t.string :comment_suspicious_cop

      t.jsonb :cops_settings
      t.jsonb :scan_settings
      t.timestamps
    end
  end
end
