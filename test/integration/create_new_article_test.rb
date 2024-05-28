require 'test_helper'

class CreateNewArticleTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = User.create(username: "test", email: "test@test.com", password: "password", admin: true)
    sign_in_as(@admin_user)
  end

  test "get new article form and create new article" do
    get "/articles/new"
    assert_response :success
    
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: "Test title", description: "Test description", category_ids: [] } }
      assert_response :redirect
    end

    follow_redirect!
    assert_response :success
    assert_match "Test title", response.body
  end

  test "get new article form and reject invalid article submission" do
    get "/articles/new"
    assert_response :success

    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: "a" * 2, description: "Test description", category_ids: [] } }
    end
    assert_match "Title is too short", response.body
    assert_select 'div.alert'

    assert_no_difference 'Article.count' do
        post articles_path, params: { article: { title: "Test title" * 2, description: "a" * 9, category_ids: [] } }
      end
      assert_match "Description is too short", response.body
      assert_select 'div.alert'
  end
end