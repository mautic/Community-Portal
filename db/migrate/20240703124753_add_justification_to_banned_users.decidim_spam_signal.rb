# frozen_string_literal: true
# This migration comes from decidim_spam_signal (originally 20220728095052)

class AddJustificationToBannedUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_banned_users, :justification, :text
  end
end
