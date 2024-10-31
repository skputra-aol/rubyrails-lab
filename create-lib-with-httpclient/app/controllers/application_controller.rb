class ApplicationController < ActionController::Base
  def client
    @client ||= Hackernews::Client.new
  end
end
