require 'test_helper'

class PinimagesControllerTest < ActionController::TestCase
  setup do
    @pinimage = pinimages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pinimages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pinimage" do
    assert_difference('Pinimage.count') do
      post :create, pinimage: { caption: @pinimage.caption, image: @pinimage.image, pin: @pinimage.pin }
    end

    assert_redirected_to pinimage_path(assigns(:pinimage))
  end

  test "should show pinimage" do
    get :show, id: @pinimage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pinimage
    assert_response :success
  end

  test "should update pinimage" do
    put :update, id: @pinimage, pinimage: { caption: @pinimage.caption, image: @pinimage.image, pin: @pinimage.pin }
    assert_redirected_to pinimage_path(assigns(:pinimage))
  end

  test "should destroy pinimage" do
    assert_difference('Pinimage.count', -1) do
      delete :destroy, id: @pinimage
    end

    assert_redirected_to pinimages_path
  end
end
