class CreatedRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.integer :rating
      t.datetime :rated_at
      t.references :user, foreign_key: {to_table: :users}
      t.references :rater, foreign_key: {to_table: :users}

      t.timestamps
    end
    add_index :ratings, :rated_at
  end
end
