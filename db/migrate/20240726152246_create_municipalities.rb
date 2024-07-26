class CreateMunicipalities < ActiveRecord::Migration[7.1]
  def change
    create_table :municipalities do |t|
      t.string :name, null: false
      
      t.timestamps
    end

    add_index :municipalities, :name, unique: true

    add_reference :packages, :municipality, foreign_key: true
    add_reference :prices, :municipality, foreign_key: true
  end
end
