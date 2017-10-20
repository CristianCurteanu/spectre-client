class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :client_id
      t.string :service_secret

      t.timestamps
    end
  end
end
