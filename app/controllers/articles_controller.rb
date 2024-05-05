class ArticlesController < ApplicationController
    def show
        @article = Article.find(params[:id]) # @ converts regular variable into instance variable
    end
end