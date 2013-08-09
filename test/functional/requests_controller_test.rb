require 'test_helper'

class RequestsControllerTest < ActionController::TestCase
  setup do
    @request = requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create request" do
    assert_difference('Request.count') do
      post :create, request: { approved_at: @request.approved_at, approver_email: @request.approver_email, begin_at: @request.begin_at, begin_at_approved: @request.begin_at_approved, comments: @request.comments, comments_approved: @request.comments_approved, days: @request.days, days_approved: @request.days_approved, end_at: @request.end_at, end_at_approved: @request.end_at_approved, requested_at: @request.requested_at, requester_email: @request.requester_email, status: @request.status }
    end

    assert_redirected_to request_path(assigns(:request))
  end

  test "should show request" do
    get :show, id: @request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @request
    assert_response :success
  end

  test "should update request" do
    put :update, id: @request, request: { approved_at: @request.approved_at, approver_email: @request.approver_email, begin_at: @request.begin_at, begin_at_approved: @request.begin_at_approved, comments: @request.comments, comments_approved: @request.comments_approved, days: @request.days, days_approved: @request.days_approved, end_at: @request.end_at, end_at_approved: @request.end_at_approved, requested_at: @request.requested_at, requester_email: @request.requester_email, status: @request.status }
    assert_redirected_to request_path(assigns(:request))
  end

  test "should destroy request" do
    assert_difference('Request.count', -1) do
      delete :destroy, id: @request
    end

    assert_redirected_to requests_path
  end
end
