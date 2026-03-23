# frozen_string_literal: true
# This migration comes from decidim_voca (originally 20251125102359)
class CreateVocaOrganizationKeyValConfig < ActiveRecord::Migration[7.0]
  def change
    create_table :voca_organization_key_val_configs do |t|
      t.references :decidim_organization, null: false, foreign_key: true, index: { name: "voca_organization_key_val_configs_constraint_organization" }
      t.string :key, null: false
      t.string :value, null: false
      t.timestamps
    end

    Decidim::Organization.find_each do |organization|
      Decidim::Voca::VocaOrganizationKeyValConfig.create(organization:, key: "external_id", value: SecureRandom.uuid)
    end
  end
end
