require 'telegram/bot'
class ChatBot
  include Interactor

  TOKEN = ENV['TELEGRAM_TOKEN']
  def call
    Telegram::Bot::Client.run(TOKEN) do |bot|
      bot.logger.info('Bot has been started')
      bot.listen do |message|
        bot.logger.info('Bot has been listened.')
        if message.text == '/start'
          bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
        elsif message.text == '/stop'
          bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
        elsif message.text[0..2] == '/ai'
          query = message.text[3..-1]
          answer = Chat.call(message: query).result
          bot.api.send_message(chat_id: message.chat.id, text: answer)
        end
      end
    end
  end
end
