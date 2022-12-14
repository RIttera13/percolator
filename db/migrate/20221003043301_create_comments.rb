class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :message
      t.datetime :commented_at
      t.belongs_to :user
      t.belongs_to :post

      t.timestamps
    end
  end
end
