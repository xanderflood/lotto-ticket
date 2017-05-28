class CreateParentProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :parent_profiles do |t|
      t.references :parent, foreign_key: true

      t.references :primary_contact,   references: :contact_info, foreign_key: true
      t.references :energency_contact, references: :contact_info, foreign_key: true

      # t.timestamps
    end
  end
end
