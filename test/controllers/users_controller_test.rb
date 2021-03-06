require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include SessionsHelper
  def setup
    @user = valid_user

  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get show" do
    log_in(@user)
    get :show, id: @user.id
    assert_response :success
  end

  test 'content of show action' do
    log_in(@user)
    get :show, id: @user.id
    assert_select 'title', /#{@user.username}/
  end

  test 'valid creation' do
    User.destroy_all
    assert_difference 'User.count', 1 do 
      post :create, user: { username: 'user12', password: 'hah1234', 
                            password_confirmation: 'hah1234'} 
    end
    assert_redirected_to :root
  end

  test 'invalid creation' do
    assert_no_difference 'User.count' do 
      post :create, user: { username: 'hi' }
    end
    assert_template :new
  end

  test 'show should redirect to root if invalid id given' do
    get :show, id: 49999
    assert_redirected_to :root
  end

  test 'edit should redirect to root if invalid id given' do
    get :edit, id: 49999
    assert_redirected_to :root
  end

end
