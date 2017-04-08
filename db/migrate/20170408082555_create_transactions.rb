class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :user_id, null: false
      t.integer :category_id, null: false
      t.float :amount, null: false

      t.timestamps
    end

     add_index :transactions, :user_id
  end
end
