class Addpaymentdetails < ActiveRecord::Migration
  def self.up
  	add_column :orders, :cart_id, :integer
  	add_column :orders, :first_name, :string
  	add_column :orders, :last_name, :string
  	add_column :orders, :card_type, :string
  	add_column :orders, :card_expires, :date
  	add_column :orders, :ip_address, :string
  	add_column :orders, :shipping_address, :string
  	add_column :orders, :billing_address, :string
  end

  def self.down
    remove_column :orders, :cart_id
    remove_column :orders, :first_name
    remove_column :orders, :last_name
    remove_column :orders, :card_type
    remove_column :orders, :card_expire
    remove_column :orders, :ip_address
    remove_column :orders, :shipping_address
    remove_column :orders, :billing_address
  end

end
