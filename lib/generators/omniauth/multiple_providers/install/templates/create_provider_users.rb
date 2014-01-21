class CreateProviderUsers < ActiveRecord::Migration
  def change
    create_table :provider_users do |t|
      t.integer :user_id
      t.string :email
      t.string :provider
      t.string :locale
      t.string :gender
      t.string :uid
      t.string :access_token
      t.string :refresh_token
      t.string :secret
      t.integer :expires_at
      t.string :nickname
      t.string :name
      t.string :image_path

      t.timestamps
    end

    add_index :provider_users, :user_id
    add_index :provider_users, :provider
    add_index :provider_users, :uid
  end
end
