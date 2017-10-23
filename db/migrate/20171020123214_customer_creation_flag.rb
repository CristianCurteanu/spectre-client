class CustomerCreationFlag < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.boolean :created_customer, default: false
    end
  end
end
