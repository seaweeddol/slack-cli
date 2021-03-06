require_relative 'test_helper'
require "./lib/workspace"

describe "Workspace" do
  before do
    VCR.use_cassette("workspace-data") do
      @workspace = Workspace.new
    end
  end

  describe "initialize" do
    it "initializes Workspace object with an array of users and channels" do
      expect(@workspace).must_be_kind_of Workspace
      expect(@workspace.users).must_be_kind_of Array
      expect(@workspace.channels).must_be_kind_of Array
    end
  end

  describe "select_channel" do
    it "sets @selected to correct Channel instance when given an ID" do
      @workspace.select_channel("slack-cli")
      
      expect(@workspace.selected).must_be_kind_of Channel
      expect(@workspace.selected.slack_id).must_equal "slack-cli"
    end

    it "sets @selected to correct Channel instance when given a username" do
      @workspace.select_channel("CV5KNMDKN")
      
      expect(@workspace.selected).must_be_kind_of Channel
      expect(@workspace.selected.name).must_equal "CV5KNMDKN"
    end

    it "sets @selected to empty if no match is found" do
      @workspace.select_channel("CV5KNMDKN")
      @workspace.select_channel("abcdef")
      
      expect(@workspace.selected).must_equal ""
    end
  end
  
  describe "select_user" do
    it "sets @selected to correct User instance when given an ID" do
      @workspace.select_user("USLACKBOT")
      
      expect(@workspace.selected).must_be_kind_of User
      expect(@workspace.selected.slack_id).must_equal "USLACKBOT"
    end

    it "sets @selected to correct User instance when given a username" do
      @workspace.select_user("slackbot")
      
      expect(@workspace.selected).must_be_kind_of User
      expect(@workspace.selected.name).must_equal "slackbot"
    end

    it "sets @selected to empty if no match is found" do
      @workspace.select_user("slackbot")
      @workspace.select_user("abcdef")
      
      expect(@workspace.selected).must_equal ""
    end

  end

  describe "show_details" do
    it "returns details for selected user or channel" do
      @workspace.selected = @workspace.users[0]
      selected = @workspace.show_details
      expect(selected).must_be_kind_of TablePrint::Returnable
    end

    it "returns nil if @selected is empty" do
      @workspace.selected = ""
      expect(@workspace.show_details).must_be_nil
    end
  end

  # I'm not sure how to test this 
  # describe "customize_bot" do
  #   before do
  #     VCR.use_cassette("workspace-customize-bot") do
  #       user = HTTParty.get("https://slack.com/api/users.info?token=xoxp-991668681700-991668681972-981605165810-99a1cdf01edb9e571ee65cc11ea6ebf1&user=UV5KNL1UL")
  #       @username = user["user"]["name"]
  #       @emoji = user["user"]["profile"]["status_emoji"]
  
  #       @workspace.customize_bot("jessica bot test", ":rainbow:")
  #     end
  #   end

  #   it "updates username and emoji" do
  #     VCR.use_cassette('workspace-customize-bot2') do
  #       user = HTTParty.get("https://slack.com/api/users.info?token=xoxp-991668681700-991668681972-981605165810-99a1cdf01edb9e571ee65cc11ea6ebf1&user=UV5KNL1UL")

  #       expect(user["user"]["name"]).wont_equal @username
  #       expect(user["user"]["profile"]["status_emoji"]).wont_equal @emoji
  #     end
  #   end
  # end
end
