class MessageCreate
  include Interactor

  def call
    current_chat = ChatMessage.find_by(telegram_chat_id: context.telegram_chat_id,
                                       telegram_user_id: context.telegram_user_id)
    if current_chat.nil?
      message = ChatMessage.new(telegram_chat_id: context.telegram_chat_id,
                                telegram_user_id: context.telegram_user_id,
                                message: context.message)
      message.save!
      context.chat = ChatMessage.find_by(telegram_chat_id: context.telegram_chat_id,
                                         telegram_user_id: context.telegram_user_id)
    else
      ChatMessage.where(telegram_chat_id: context.telegram_chat_id,
                        telegram_user_id: context.telegram_user_id).update_all(message: "#{current_chat.message}\n#{context.message}")
      context.chat = ChatMessage.find_by(telegram_chat_id: context.telegram_chat_id,
                                         telegram_user_id: context.telegram_user_id)
    end
  end
end
