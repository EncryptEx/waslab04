require "test_helper"

class TweetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tweet = tweets(:one)
  end

  test "should get index" do
    get tweets_url
    assert_response :success
  end

  test "should create tweet" do
    assert_difference("Tweet.count") do
      post tweets_url, params: { tweet: { author: @tweet.author, content: @tweet.content } }
    end

    assert_redirected_to tweets_url
  end

  test "should like tweet" do
    assert_difference("@tweet.reload.likes.to_i", 1) do
      put like_tweet_url(@tweet)
    end

    assert_redirected_to tweets_url
  end

  test "should not destroy unowned tweet" do
    assert_no_difference("Tweet.count") do
      delete tweet_url(@tweet)
    end

    assert_redirected_to tweets_url
  end

  test "should destroy owned tweet" do
    post tweets_url, params: { tweet: { author: "Owner", content: "Owned tweet" } }
    owned_tweet = Tweet.order(:created_at).last

    assert_difference("Tweet.count", -1) do
      delete tweet_url(owned_tweet)
    end

    assert_redirected_to tweets_url
  end
end
