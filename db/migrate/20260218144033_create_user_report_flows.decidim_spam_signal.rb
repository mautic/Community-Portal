# frozen_string_literal: true
# This migration comes from decidim_spam_signal (originally 20251029200108)
class CreateUserReportFlows < ActiveRecord::Migration[7.0]
  def change
    create_table :user_report_flows do |t|
      t.references :anti_spam_flows, foreign_key: true
      t.references :decidim_user_report, foreign_key: true

      t.timestamps
    end
  end
end
