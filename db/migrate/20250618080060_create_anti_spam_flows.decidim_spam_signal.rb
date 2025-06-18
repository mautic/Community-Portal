# frozen_string_literal: true

# This migration comes from decidim_spam_signal (originally 20250328155013)
class CreateAntiSpamFlows < ActiveRecord::Migration[7.0]
  def change
    create_table :anti_spam_flows do |t|
      t.string :name
      t.string :trigger_type
      t.references :decidim_organization, foreign_key: true, index: true

      # each trigger have it's own settings forms and validation
      t.jsonb :action_settings
      t.timestamps
    end

    # Join table between anti_spam_flows and anti_spam_conditions
    create_table :anti_spam_flows_conditions do |t|
      t.references :anti_spam_flow, null: false, foreign_key: true
      t.references :anti_spam_condition, null: false, foreign_key: true
      t.timestamps
    end
  end
end
