# frozen_string_literal: true
# This migration comes from decidim_voca (originally 20250707062607)
class CreateEditorFileTable < ActiveRecord::Migration[7.0]
  def change
    create_table :decidim_voca_editor_files do |t|
      t.string :file
      t.string :path
      t.references :decidim_author, null: false, foreign_key: { to_table: :decidim_users }, index: { name: "decidim_voca_editor_files_author" }
      t.references :decidim_organization, null: false, foreign_key: true, index: { name: "decidim_voca_editor_files_constraint_organization" }

      t.timestamps
    end
  end
end
