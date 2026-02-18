# frozen_string_literal: true
# This migration comes from decidim_spam_signal (originally 20250626102158)
class MigrateFromV0 < ActiveRecord::Migration[7.0]
  class Decidim::SpamSignal::V0Config < ApplicationRecord
    self.table_name = "spam_signal_config_tables"
  end

  def compute_conditions(condition_name, condition_suffix, flow, organization)
    case condition_name
    when "word_found"
      {
        name: "#{condition_name.titleize} ##{condition_suffix}",
        condition_type: "word",
        settings: {
          stop_list_words_csv: flow["scans"]["word"]["stop_list_words_csv"]
        },
        organization:
      }
    when "forbidden_tlds_found"
      {
        name: "#{condition_name.titleize} ##{condition_suffix}",
        condition_type: "forbidden_tlds",
        settings: {
          forbidden_tlds_csv: flow["scans"]["forbidden_tlds"]["forbidden_tlds_csv"]
        },
        organization:
      }
    when "not_allowed_tlds_found"
      {
        name: "#{condition_name.titleize} ##{condition_suffix}",
        condition_type: "allowed_tlds",
        settings: {
          allowed_tlds_csv: flow["scans"]["allowed_tlds"]["allowed_tlds_csv"]
        },
        organization:
      }
    else
      raise "Unknown condition: #{condition_name}"
    end
  end

  def migrate_conditions(conditions, organization, trigger_type, flow_index, rule_config)
    flow_name = "#{rule_config["rules"].keys.map(&:titleize).join(", ")} is #{rule_config["handler_name"]}"
    actions = Decidim::SpamSignal.config.actions_registry.names.filter do |action_name|
      klass = trigger_type.constantize
      klass.available_actions.include?(action_name)
    end
    actions_form = actions.map do |action_name|
      Decidim::SpamSignal.config.actions_registry.form_for(action_name).new.with_context(
        handler_name: trigger_type
      )
    end
    Rails.logger.debug { "Saving flow: #{flow_name}" }
    Rails.logger.debug { "Trigger type: #{trigger_type}" }
    Rails.logger.debug { "Action settings: #{actions_form.map(&:attributes)}" }
    flow_object = Decidim::SpamSignal::Flow.create(
      name: flow_name,
      trigger_type:,
      organization:,
      action_settings: actions_form.map(&:attributes)
    )
    rule_config["rules"].keys.each_with_index do |condition_name, index|
      condition_suffix = (index + 1) * (flow_index + 1)
      condition_key = "#{condition_name}##{condition_suffix}"
      Rails.logger.debug { "Saving flow condition: #{condition_key}" }
      Rails.logger.debug { "Condition id: #{conditions[condition_key]["id"]}" }
      Rails.logger.debug { "Flow id: #{flow_object.id}" }
      Decidim::SpamSignal::FlowCondition.create!(
        anti_spam_condition_id: conditions[condition_key]["id"].id,
        anti_spam_flow_id: flow_object.id
      )
    end
  end

  def change
    Rails.logger.debug "Migrate old configuration from v0.0.x"
    organization = Decidim::Organization.first
    conditions = {}
    Decidim::SpamSignal::V0Config.all.each do |config|
      comment_flow = config.comment_settings
      profile_flow = config.profile_settings
      trigger_types = ["Decidim::SpamSignal::Flows::CommentFlow",
                       "Decidim::SpamSignal::Flows::ProfileFlow"]
      [comment_flow, profile_flow].each_with_index do |flow, flow_index|
        trigger_type = trigger_types[flow_index]
        flow["rules"].map do |_rule_name, rule_config|
          rule_config["rules"].keys.each_with_index do |condition_name, index|
            condition_suffix = (index + 1) * (flow_index + 1)
            condition_key = "#{condition_name}##{condition_suffix}"
            next if conditions.has_key?(condition_key)

            conditions[condition_key] = compute_conditions(condition_name, condition_suffix, flow, organization)
            # Save the conditions in DB
            Rails.logger.debug { "Saving condition: #{condition_key}" }
            Rails.logger.debug conditions[condition_key]
            conditions[condition_key]["id"] = ::Decidim::SpamSignal::Condition.find_or_create_by(
              **conditions[condition_key]
            )
          end
          migrate_conditions(conditions, organization, trigger_type, flow_index, rule_config)
        end
      end
    end
  end
end
