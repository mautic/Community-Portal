# frozen_string_literal: true
# This migration comes from decidim_voca (originally 20251215095441)
class CreateValidationCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :voca_validation_codes do |t|
      t.string :code
      t.references :decidim_organization, foreign_key: true, index: { name: "index_voca_verifications_code_census_to_organization" }
      t.timestamps
    end
  end
end
