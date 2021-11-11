# frozen_string_literal: true

module PortfolioAdvisor
    module Mapper
        class ArticleScore
            attr_reader :article,
                        :content
            def initialize(article, content)
                @article = article
                @content = content
            end

            def build_entity
                Entity::ArticleScore.new(
                    title: @article.title,
                    url: @article.url,
                    published_at: @article.published_at,
                    content: @content
                )
            end
        end
    end
end