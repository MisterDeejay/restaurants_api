class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    enable_extension "plpgsql" unless extension_enabled?('plpgsql')
    enable_extension "pg_trgm" unless extension_enabled?('pg_trgm')
    enable_extension "fuzzystrmatch" unless extension_enabled?('fuzzystrmatch')
    enable_extension "btree_gin" unless extension_enabled?('btree_gin')

    create_table :restaurants do |t|
      t.string :name, null: false, index: { unique: true }
      t.hstore :hours
      t.timestamps
    end

    add_index :restaurants, :hours, using: :gin
  end
end
