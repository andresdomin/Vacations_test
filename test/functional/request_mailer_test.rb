require 'test_helper'

class RequestMailerTest < ActionMailer::TestCase
  test "create_request" do
    mail = RequestMailer.create_request
    assert_equal "Create request", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "bulk_requests" do
    mail = RequestMailer.bulk_requests
    assert_equal "Bulk requests", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "approve_request" do
    mail = RequestMailer.approve_request
    assert_equal "Approve request", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
