class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|

      t.references :user, foreign_key: true, null: false
      t.references :variablecost_value, foreign_key: true, null: false
      t.text :comment, null: false #コメント

      t.timestamps
    end
  end
end
