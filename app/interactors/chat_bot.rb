require 'telegram/bot'
class ChatBot
  include Interactor

  TOKEN = ENV['TELEGRAM_TOKEN']
  PARAM_ERROR = "Please ask your question from AI like: \n/ai what is AI?"
  HELP = "Ask question: /ai\nNew chat: /new"
  NEW_CHAT = "You are in new chat.\n"
  ALERT_MESSAGE = "You don't need to use /ai command."

  def call
    Telegram::Bot::Client.run(TOKEN) do |bot|
      bot.logger.info('Bot has been started')
      bot.listen do |message|
        bot.logger.info('Bot has been listened.')
        begin
          if message.text == '/start'
            bot.api.send_message(chat_id: message.chat.id,
                                 text: "Hello, #{message.from.first_name}\n#{PARAM_ERROR}")
          elsif message.text == '/stop'
            bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
          elsif message.text == '/help'
            bot.api.send_message(chat_id: message.chat.id,
                                 reply_to_message_id: message.message_id,
                                 text: HELP)
          elsif message.text[0..2] == '/ai'
            ai_answer = response_create(message)
            bot.api.send_message(chat_id: message.chat.id,
                                 text: ALERT_MESSAGE)
            bot.api.send_message(chat_id: message.chat.id,
                                 reply_to_message_id: message.message_id,
                                 text: ai_answer)
          elsif message.text[0..3] == '/new'
            Rails.logger.info("message.chat.id: #{message.chat.id}, message.from.id: #{message.from.id}")
            ChatMessage.where(telegram_chat_id: message.chat.id, telegram_user_id: message.from.id).delete_all
            bot.api.send_message(chat_id: message.chat.id, text: "#{NEW_CHAT}#{PARAM_ERROR}")
          else
            ai_answer = response_create(message)
            bot.api.send_message(chat_id: message.chat.id,
                                 reply_to_message_id: message.message_id,
                                 text: ai_answer)
          end
        rescue StandardError => e
          Rails.logger.info(e.message)
          # SendAlarm.call(message: e.message)
        end
      end
    end
  end
  
  private
  def response_create(message_obj)
    query = message_obj.text[3..-1]
    result = MessageCreate.call(telegram_chat_id: message_obj.chat.id,
                                telegram_user_id: message_obj.from.id,
                                message: query).chat
    Rails.logger.info("Message from result: #{result.message}")
    answer = Chat.call(message: result.message).result
    MessageCreate.call(telegram_chat_id: message_obj.chat.id,
                                telegram_user_id: message_obj.from.id,
                                message: answer).chat
    answer
  end
end
