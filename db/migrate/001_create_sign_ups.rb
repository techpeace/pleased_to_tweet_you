class CreateSignUps < ActiveRecord::Migration
  def self.up
    create_table :sign_ups do |t|
      t.column :name, :string
      t.column :email, :string
      t.column :twitter_username, :string
      t.column :show_name, :boolean, :default => true
      t.column :email_opt_in, :boolean, :default => false
      t.column :member_of_press, :boolean, :default => false
      t.column :tweeted, :boolean, :default => false
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :sign_ups
  end
end
