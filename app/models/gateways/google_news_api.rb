require 'http'
module NewsArticle
  # Library for GoogleNews API
module  GoogleNews
  class Api
   def initialize(token)
      @gn_token = token
    end

    # def testing(topic, result_num)
    #   article = article(topic, result_num)
    #   puts article.time[0]
    # end

   

    def article(topic, result_num)
      article_req_url = Request.new(@gn_token).gn_api_path(topic, result_num)
      article_data = Request.new(@gn_token).get(article_req_url).parse
    end

     class Request
      
     API_GOOGLE_NEWS_EVERYTHING = 'https://newsapi.org/v2/everything?'


    def gn_api_path(topic, result_num)
      path = "q=#{topic}&from=2021-10-1&to=2021-10-15&pageSize=#{result_num}"
      "#{API_GOOGLE_NEWS_EVERYTHING}#{path}"
    end

    def get(url)
      http_response=
        HTTP.headers('Accept' => 'json',
                     'Authorization' => "token #{@api_key}")
            .get(url)

     Response.new(http_response).tap do |response|
       raise(response.error)unless response.successful?
     end
end
end

  # Decorates HTTP responses from NewsAPI with failure/success status
      class Response < SimpleDelegator
        Unauthorized = Class.new(StandardError)
        NotFound = Class.new(StandardError)
        BadRequest=Class.new(StandardError)
        HTTP_ERROR = {
          400=> BadRequest,
          401 => Unauthorized,
          404 => NotFound
        }.freeze

        def successful?
          HTTP_ERROR.keys.include?(code) ? false : true
        end

        def error
          HTTP_ERROR[code]
        end
      end      
end
end
end

