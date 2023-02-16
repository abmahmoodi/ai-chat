namespace :bot do
  task start: :environment do
    ChatBot.call
  end
end
