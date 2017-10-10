class CreateKittens < ActiveRecord::Migration[5.1]
  def change
    create_table :kittens do |t|
      t.string :name
      t.string :color
      t.string :quirk
    end
  end
end
