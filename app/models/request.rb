class Request < ActiveRecord::Base
  after_create :create_request_notification
  after_update :approve_request_notification
  
  attr_accessible :approver_email, :begin_at, :begin_at_approved,
                  :comments, :comments_approved, :days, :days_approved,
                  :pay_days, :end_at, :end_at_approved, :requested_at, :requester_email, :status, :days_approved, :pay_days_approved, :approved_at, :letter, :return_at
                  
  validates_presence_of :approver_email, :begin_at, :end_at, :days
  
  scope :today, :conditions => ["DATE(approved_at) = DATE(?) AND status != 'Pendiente'", Time.now]
  
  def self.send_today_requests
    requests =  Request.today
    if requests.size > 0
      RequestMailer.bulk_requests(requests).deliver
    end
  end

  def approver
    User.find_by_email(self.approver_email)
  end

  def requester
    User.find_by_email(self.requester_email)
  end
  
  private
  
  def create_request_notification
    RequestMailer.create_request(self).deliver
  end
  
  def approve_request_notification
    RequestMailer.approve_request(self).deliver
  end

end
