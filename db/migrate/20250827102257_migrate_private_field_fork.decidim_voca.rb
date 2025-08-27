# frozen_string_literal: true
# This migration comes from decidim_voca (originally 20250702090326)
class MigratePrivateFieldFork < ActiveRecord::Migration[7.0]
  class OldPrivateField < ApplicationRecord
    self.table_name = "decidim_awesome_private_proposal_fields"
  end

  def change
    # Ignore if table name does not exists
    return unless can_change?

    # Migrate private fields structure
    migrate_structure
    # Migrate private fields content
    migrate_content
    # Drop old table
    drop_table :decidim_awesome_private_proposal_fields
  end

  private

  def can_change?
    OldPrivateField.table_exists? && const_defined?(Decidim::DecidimAwesome)
  end

  def migrate_structure
    deprecated_configs = []
    Decidim::Organization.find_each do |organization|
      private_fields = Decidim::DecidimAwesome::AwesomeConfig.find_by(var: :private_proposal_custom_fields, organization:)
      # Update private fields
      private_fields.value.each do |key, value|
        # Create new configuration
        private_config = Decidim::DecidimAwesome::AwesomeConfig.find_or_initialize_by(
          var: "proposal_private_custom_fields",
          organization:
        )
        private_config.value = {} unless private_config.value
        private_config.value[key] = value
        private_config.save!
        private_config.reload

        private_subconfig = Decidim::DecidimAwesome::AwesomeConfig.find_or_create_by(var: "proposal_private_custom_field_#{key}", organization:)

        # If an existing public field with same key is found, copy the constraints
        public_field = Decidim::DecidimAwesome::AwesomeConfig.find_by(var: "proposal_custom_field_#{key}")
        unless public_field
          Rails.logger.warn "Public field #{key} not found. Skipping..."
          next
        end
        public_constraint = Decidim::DecidimAwesome::ConfigConstraint.where(
          awesome_config: public_field
        )
        public_constraint.each do |constraint|
          next if Decidim::DecidimAwesome::ConfigConstraint.exists?(awesome_config: private_subconfig)

          Decidim::DecidimAwesome::ConfigConstraint.create!(
            awesome_config: private_subconfig,
            settings: constraint.settings
          )
        end
      end
      deprecated_configs << private_fields
    end

    # Drop deprecated configs
    deprecated_configs.each(&:destroy)
  end

  def migrate_content
    OldPrivateField.find_each do |old_private_field|
      private_body_content = old_private_field.private_body
      proposal = Decidim::Proposals::Proposal.find(old_private_field.proposal_id)
      next unless proposal

      extra_field = Decidim::DecidimAwesome::ProposalExtraField.find_by(proposal:)
      unless extra_field
        Rails.logger.warn "ProposalExtraField not found for proposal #{proposal.id}. Creating new one."
        extra_field = Decidim::DecidimAwesome::ProposalExtraField.new(proposal:)
        extra_field.save!
        extra_field.reload
      end
      proposal.update_private_body!(private_body_content)
    end
  end
end
