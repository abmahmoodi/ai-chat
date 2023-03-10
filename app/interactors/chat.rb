class Chat
  include Interactor

  TOKEN = ENV['OPENAI_TOKEN']
  BASE_URI = 'https://api.openai.com/v1/completions'
  MAX_TOKENS = 256
  
  def call
    result = HTTParty.post("#{BASE_URI}",
                           :headers => { 'Content-Type': 'application/json', 'Authorization' => "Bearer #{TOKEN}" },
                           :bearer_token => { 'Token': TOKEN  },
                           :body => { "model": "text-davinci-003",
                                      "prompt": context.message,
                                      "max_tokens": MAX_TOKENS,
                                      "temperature": 0.7,
                                      "top_p": 1,
                                      "frequency_penalty": 0,
                                      "presence_penalty": 0.6
                           }.to_json)
    Rails.logger.info "Response Result: #{result}"
    if result['id'].present?
      context.result = result['choices'][0]['text']
    end
  end
end
