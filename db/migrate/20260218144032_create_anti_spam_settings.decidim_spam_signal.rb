# frozen_string_literal: true

# This migration comes from decidim_spam_signal (originally 20251023064715)
class CreateAntiSpamSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :anti_spam_settings do |t|
      t.string :anti_spam_mode
      t.belongs_to :decidim_organization, foreign_key: true

      t.timestamps
    end
  end
end
