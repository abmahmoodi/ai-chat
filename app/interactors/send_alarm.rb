class SendAlarm
  include Interactor

  TOKEN = ENV['TELEGRAM_TOKEN']
  TELEGRAM_ENDPOINT = 'https://api.telegram.org/'
  CHAT_ID = ENV['AI_CHAT_BOT_ALARM']
  def call
    result = HTTParty.get("#{TELEGRAM_ENDPOINT}bot#{TOKEN}/sendMessage?chat_id=#{CHAT_ID}&text=#{context.message}",
                           :headers => { 'Content-Type': 'application/json', 'Authorization' => "Bearer #{TOKEN}" })
    Rails.logger.info "Response Result: #{result}"
    # if result['id'].present?
    #   context.result = result['choices'][0]['text']
    # end
  end
end
