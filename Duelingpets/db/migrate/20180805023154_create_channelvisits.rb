class CreateChannelvisits < ActiveRecord::Migration
  def change
    create_table :channelvisits do |t|
      t.datetime :created_on
      t.integer :user_id
      t.integer :channel_id

      t.timestamps
    end
  end
end
