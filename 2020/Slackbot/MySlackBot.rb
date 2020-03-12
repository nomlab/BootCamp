# coding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'SlackBot'

class MySlackBot < SlackBot
  # cool code goes here
  def say_message(msg)
    start = msg.index("「")
    finish = msg.rindex("」と言って")
    if msg[start..finish].include?("「") &&
       msg[start..finish].include?("」と言って") then
      start_two = msg.index("「",start+1)
      finish_two = msg.rindex("」と言って",finish-1)
      if start_two>finish_two then
        start += 1
        finish -= 1
        start_two += 1
        finish_two -= 1
        return msg[start..finish_two] +" " + msg[start_two..finish]
      end
    end
    start += 1
    finish -= 1
    return msg[start..finish]
  end

  def hello
    return "こんにちは zono-botです．\n「◯◯」と言って：◯◯と発言します．\n「◯◯」で検索：◯◯で検索し最大5件の飲食店情報を表示します．\nstatus：現在の検索ワード，該当件数，ページ番号を表示します．\nprevious：前ページの飲食店情報を表示します．\nnext：次ページの飲食店情報を表示します．\njump n：nページ目の飲食店情報を表示します．\n\n"
  end

end

slackbot = MySlackBot.new

set :environment, :production

get '/' do
  "SlackBot Server"
end

post '/slack' do
  content_type :json

  return nil if params[:user_name] == "slackbot" || params[:user_id] == "USLACKBOT"

  #if params[:text].include?("「")&&params[:text].include?("」と言って") then
  #  params[:text] = slackbot.say_message(params[:text])
  #end
  print(params[:text])
    
  slackbot.naive_respond(params, username:"zono-bot")
end
