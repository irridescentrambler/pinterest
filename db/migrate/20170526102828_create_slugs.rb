class CreateSlugs < ActiveRecord::Migration
  def change
    create_table :slugs do |t|

      t.timestamps null: false
    end
  end
end
