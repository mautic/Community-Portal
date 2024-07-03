# frozen_string_literal: true
# This migration comes from decidim_spam_signal (originally 20221010141920)

class DropQuarantine < ActiveRecord::Migration[5.2]
  def change
    drop_table :decidim_banned_users
  end
end
