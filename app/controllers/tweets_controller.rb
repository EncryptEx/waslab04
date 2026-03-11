class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[ destroy like ]

  # GET /tweets
  def index
    @tweets = Tweet.all.order(created_at: :desc)
  end


  # POST /tweets
  def create
    @tweet = Tweet.new(tweet_params)

    if @tweet.save
      if session[:created_ids].nil?
       session[:created_ids] = [@tweet.id]
      else
       session[:created_ids] << @tweet.id
      end
      redirect_to tweets_path, notice: "Tweet was successfully created."
    else
      @tweets = Tweet.all.order(created_at: :desc)
      render :index, status: :unprocessable_content
    end
  end

  # DELETE /tweets/1
  def destroy
    if session[:created_ids].nil? || !session[:created_ids].include?(@tweet.id)
      redirect_to tweets_path, alert: "You are not allowed to delete this tweet", status: :see_other
    else
      @tweet.destroy!
      session[:created_ids] = session[:created_ids] - [@tweet.id.to_s]
      redirect_to tweets_path, notice: "Tweet was successfully destroyed.", status: :see_other
    end
  end


  def like
    @tweet.increment!(:likes)
    redirect_to tweets_path, status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.expect(tweet: [ :author, :content ])
    end
end
