require 'telegram/bot'
class ChatBot
  include Interactor

  TOKEN = ENV['TELEGRAM_TOKEN']
  PARAM_ERROR = "Please ask your question from AI like: \n/ai what is AI?"
  HELP = "Ask question: /ai\nNew chat: /new"
  NEW_CHAT = "You are in new chat.\n"

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
            query = message.text[3..-1]
            result = MessageCreate.call(telegram_chat_id: message.chat.id,
                                        telegram_user_id: message.from.id,
                                        message: query).chat
            answer = Chat.call(message: result.message).result
            bot.api.send_message(chat_id: message.chat.id,
                                 reply_to_message_id: message.message_id,
                                 text: answer)
          elsif message.text[0..2] == '/new'
            ChatMessage.where(telegram_chat_id: message.chat.id).delete_all
            bot.api.send_message(chat_id: message.chat.id, text: PARAM_ERROR)
          else
            bot.api.send_message(chat_id: message.chat.id, text: "#{NEW_CHAT}#{PARAM_ERROR}")
          end
        rescue StandardError => e
          Rails.logger.info(e.message)
          # SendAlarm.call(message: e.message)
        end
      end
    end
  end
end
