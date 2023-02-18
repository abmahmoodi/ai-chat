require 'telegram/bot'
class ChatBot
  include Interactor

  TOKEN = ENV['TELEGRAM_TOKEN']
  PARAM_ERROR = 'Please ask your question with /ai like /ai what is AI?'

  def call
    Telegram::Bot::Client.run(TOKEN) do |bot|
      bot.logger.info('Bot has been started')
      bot.listen do |message|
        bot.logger.info('Bot has been listened.')
        begin
        if message.text == '/start'
          bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
        elsif message.text == '/stop'
          bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
        elsif message.text[0..2] == '/ai'
          query = message.text[3..-1]
          answer = Chat.call(message: query).result
          bot.api.send_message(chat_id: message.chat.id,
                               reply_to_message_id: message.message_id,
                               text: answer)
        else
          bot.api.send_message(chat_id: message.chat.id, text: PARAM_ERROR)
        end
        rescue StandardError => e
          Rails.logger.info(e.message)
        end
      end
    end
  end
end
