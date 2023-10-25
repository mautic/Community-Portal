# frozen_string_literal: true
# This migration comes from decidim_only_forms (originally 20230620184208)

class CreateDoorkeeperTables < ActiveRecord::Migration[6.1]
  def change
    # Uncomment below to ensure a valid reference to the resource owner's table
    # add_foreign_key :oauth_access_grants, <model>, column: :resource_owner_id
    # add_foreign_key :oauth_access_tokens, <model>, column: :resource_owner_id
  end
end
