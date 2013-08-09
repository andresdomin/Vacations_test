# encoding: utf-8
class RequestMailer < ActionMailer::Base
  helper :users
  
  default from: "solicitudesvacaciones@intergrupo.com"

  def create_request(request)
    @request = request
    user = User.find_by_email(@request.requester_email)
    if user
      @vacations = Vacations.find_by_identification(user.identification)
      @last_month = Time.now.at_end_of_month - 1.month
    end
    leader_info=Leaders.find_by_email(@request.approver_email)
    if leader_info
      super_leader_info=Leaders.find_by_identification(leader_info.leader_id)
        if super_leader_info.email.to_s == 'jpeñaranda@intergrupo.com'
          super_leader_info.email = 'jpenaranda@intergrupo.com'
        end
      copy = request.requester_email.to_s + ", " + super_leader_info.email.to_s
    else
      copy = request.requester_email.to_s
    end
    if request.approver_email.to_s == 'jpeñaranda@intergrupo.com'
      request.approver_email = 'jpenaranda@intergrupo.com'
    end

    mail to: request.approver_email, cc: copy, subject: '[VACACIONES] Se ha creado una nueva solicitud de vacaciones'
  end

  def bulk_requests(requests)
    @requests = requests
    mail to: 'adominguez@intergrupo.com', subject: '[VACACIONES] Informe de solicitudes del dia'
  end

  def approve_request(request)
    @request = request

    user = User.find_by_email(@request.requester_email)
    if user
      @vacations = Vacations.find_by_identification(user.identification)
      @last_month = Time.now.at_end_of_month - 1.month
    end

    subject = '[VACACIONES] Se ha '+ @request.status + ' la solicitud de vacaciones'  
    mail to: request.requester_email , subject: subject
  end

end
