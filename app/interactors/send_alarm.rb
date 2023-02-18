class SendAlarm
  include Interactor

  TOKEN = ENV['OPENAI_TOKEN']
  TELEGRAM_ENDPOINT = 'https://api.telegram.org/'
  CHAT_ID = '@ai_chat_bot_alarm'
  def call
    result = HTTParty.get("#{TELEGRAM_ENDPOINT}bot#{TOKEN}/sendMessage?chat_id=#{CHAT_ID}&text=#{context.message}",
                           :headers => { 'Content-Type': 'application/json', 'Authorization' => "Bearer #{TOKEN}" })
    Rails.logger.info "Response Result: #{result}"
    # if result['id'].present?
    #   context.result = result['choices'][0]['text']
    # end
  end
end
