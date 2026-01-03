class AddSlugToTournaments < ActiveRecord::Migration[8.0]
  def change
    add_column :tournaments, :slug, :string

    reversible do |dir|
      dir.up do
        Tournament.find_each do |tournament|
          base_slug = tournament.name.parameterize
          slug = base_slug
          while Tournament.where(slug: slug).where.not(id: tournament.id).exists?
            suffix = SecureRandom.alphanumeric(4).downcase
            slug = "#{base_slug}-#{suffix}"
          end
          tournament.update_column(:slug, slug)
        end
      end
    end

    change_column_null :tournaments, :slug, false
    add_index :tournaments, :slug, unique: true
  end
end
