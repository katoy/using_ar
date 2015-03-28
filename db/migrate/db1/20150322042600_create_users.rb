#coding: utf-8
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name,  null: false,  limit: 32
      t.string :email, null: false,  limit: 256

      t.timestamps  null: false
      t.integer :lock_version, :default => 0
    end

    add_index :users, :name, unique: true
    add_index :users, :email, unique: true
  end
end
