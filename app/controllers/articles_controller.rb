class ArticlesController < ApplicationController
    def show
        @article = Article.find(params[:id]) # @ converts regular variable into instance variable
    end

    def index
        @articles = Article.all
    end

    def new
    end

    def create
        @article = Article.new(params.require(:article).permit(:title, :description))
        @article.save
        redirect_to @article
    end
end