class CreateChatMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_messages do |t|
      t.bigint :telegram_chat_id
      t.bigint :telegram_user_id
      t.string :message, limit: 10000

      t.timestamps
    end
  end
end
