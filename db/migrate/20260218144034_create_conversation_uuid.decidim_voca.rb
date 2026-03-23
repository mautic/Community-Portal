# frozen_string_literal: true
# This migration comes from decidim_voca (originally 20251024075854)
class CreateConversationUuid < ActiveRecord::Migration[7.0]
  def change
    create_table :decidim_voca_conversation_uuids do |t|
      t.string :uuid, default: -> { "gen_random_uuid()" }
      t.references :decidim_conversation, null: false, index: { name: "decidim_voca_conversation_uuid" }
      t.timestamps
    end
  end
end
