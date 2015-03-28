#coding: utf-8
class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.string :name,          null: false,  limit: 32
      t.string :address,       null: false,  limit: 256

      t.timestamps             null:false
      t.integer :lock_version, :default => 0
    end

    add_index :infos, :name, unique: true
  end
end
