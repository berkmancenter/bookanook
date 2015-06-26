require 'test_helper'

class NooksControllerTest < ActionController::TestCase
  setup do
    @nook = nooks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nooks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nook" do
    assert_difference('Nook.count') do
      post :create, nook: {  }
    end

    assert_redirected_to nook_path(assigns(:nook))
  end

  test "should show nook" do
    get :show, id: @nook
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nook
    assert_response :success
  end

  test "should update nook" do
    patch :update, id: @nook, nook: {  }
    assert_redirected_to nook_path(assigns(:nook))
  end

  test "should destroy nook" do
    assert_difference('Nook.count', -1) do
      delete :destroy, id: @nook
    end

    assert_redirected_to nooks_path
  end
end
