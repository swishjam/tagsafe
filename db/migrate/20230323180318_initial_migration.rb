class InitialMigration < ActiveRecord::Migration[6.1]
  def up
    create_table :organizations do |t|
      t.string :name
      t.string :unique_key
      t.timestamps
    end

    create_table :users do |t|
      t.references :organization, null: false
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.timestamps
    end

    create_table :tags do |t|
      t.references :organization
      t.text :full_url
      t.string :url_host
      t.string :url_path
      t.string :url_query
      t.string :current_version_host_url
      t.timestamps
    end

    create_table :tag_versions do |t|
      t.references :tag
      t.string :version_key
      t.string :hashed_content
      t.string :original_content_host_url
      t.string :minified_content_host_url
      t.string :sha_256
      t.string :sha_512
      t.integer :original_content_byte_size
      t.integer :minified_byte_size
      t.timestamps
    end

    create_table :release_checks do |t|
      t.references :tag
      t.timestamp :created_at
    end
  end

  def down
    drop_table :users
    drop_table :organizations
    drop_table :tags
    drop_table :tag_versions
    drop_table :release_checks
  end
end
