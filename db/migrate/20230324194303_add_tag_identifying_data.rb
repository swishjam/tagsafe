class AddTagIdentifyingData < ActiveRecord::Migration[6.1]
  def up
    create_table :tag_identifying_data do |t|
      t.string :name
      t.string :company
      t.string :homepage
      t.string :category
    end

    create_table :tag_identifying_data_domains do |t|
      t.references :tag_identifying_data, null: false
      t.string :url_pattern, index: true
    end

    add_reference :tags, :tag_identifying_data, null: true
  end

  def down
    drop_table :tag_identifying_data
    drop_table :tag_identifying_data_domains
  end
end
