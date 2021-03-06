require_relative 'recipient'
require 'table_print'

class User < Recipient
  attr_reader :slack_id, :name, :real_name, :status_text, :status_emoji

  def initialize(slack_id, name, real_name, status_text, status_emoji)
    super(slack_id, name)
    @real_name = real_name
    @status_text = status_text
    @status_emoji = status_emoji
  end

  def details
    return tp self, :slack_id, :name, :real_name, :status_text, :status_emoji
  end

  def self.list_all
    response = self.get("users.list")
    all = response["members"].map do |member|
      User.new(
        member["id"],
        member["name"],
        member["real_name"],
        member["profile"]["status_text"],
        member["profile"]["status_emoji"]
      )
    end
    return all
  end

end