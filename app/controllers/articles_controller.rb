class ArticlesController < ApplicationController
    def show
        @article = Article.find(params[:id])
    end

    def index
        @articles = Article.all
    end

    def new
        @article = Article.new
    end

    def create
        @article = Article.new(params.require(:article).permit(:title, :description))
        if @article.save
            puts "article was saved"
            flash[:notice] = "Article was created successfully."
            redirect_to @article
          else
            puts "article could not be saved"
            render 'new'
        end
    end
end