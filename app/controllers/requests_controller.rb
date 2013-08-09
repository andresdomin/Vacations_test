class RequestsController < ApplicationController
  before_filter :authenticate_user!

  # GET /requests
  # GET /requests.json
  def index
    if current_user.try(:admin?)
      @requests = Request.all
    else
      @requests = Request.find(:all, :conditions => ['requester_email = ? OR approver_email = ?', current_user.email, current_user.email])
    end

  end

  # GET /requests/1
  # GET /requests/1.json
  def show
    @request = Request.find(params[:id])

    @current_leader_info = Leaders.find_by_email(current_user.email.strip.downcase)
    @approver_info = Leaders.find_by_email(@request.approver_email)

    @is_admin = (current_user.admin == true)
    if @current_leader_info && @approver_info
      @is_approver = (current_user.email.strip.downcase == @request.approver_email.strip.downcase) || (@current_leader_info.identification.to_s == @approver_info.leader_id.to_s)
    else
      @is_approver = (current_user.email.strip.downcase == @request.approver_email.strip.downcase) 
    end
    @is_requester = current_user.email.strip.downcase == @request.requester_email.strip.downcase

    @user = User.find_by_email(@request.requester_email.strip.downcase)
    @last_month = Time.now.at_end_of_month - 1.month
    if @user
      @vacations = Vacations.find_by_identification(@user.identification)
    end

    unless current_user.try(:admin?) || @is_requester || @is_approver
      redirect_to requests_path, alert: 'No tiene permisos para ver este recurso'
    end

  end

  # GET /requests/new
  # GET /requests/new.json
  def new
    @request = Request.new
    @vacations = Vacations.find_by_identification(current_user.identification)
    @last_month = Time.now.at_end_of_month - 1.month
    @user_requests = Request.find :all, :conditions => ['(status = "Aprobado" or status = "Pendiente") and requester_email = ?', current_user.email]

    if @user_requests
      @user_requests.each do |request|
        if request.status == "Aprobado"
          beginning = request.begin_at_approved.to_datetime.strftime("%Y/%m/%d")
          ending= request.end_at_approved.to_datetime.strftime("%Y/%m/%d")
          if Time.now.strftime("%Y/%m/%d") <= ending && Time.now.strftime("%Y/%m/%d") >= beginning
            @not_show = true
          else
            @not_show = false
          end
        end 
      end
      @user_requests.each do |request|
        if request.status == "Pendiente"  
          @several_requests = true
        else
          @several_requests = false
        end
      end
    end
    if @vacations
      @disabled =  @vacations.available_days < 3
    else
      @disabled = true
    end

  end

  # PUT /requests/1
  def update
    @request = Request.find(params[:id])

    params[:request][:approved_at] = Time.now

    if params[:request][:status] == 'Aprobar'
      params[:request][:status] = "Aprobado"
    else
       params[:request][:status] = "Rechazado"
    end

    if @request.update_attributes(params[:request])
      redirect_to requests_path, notice: 'Solicitud actualizada satisfactoriamente'
    else
      redirect_to requests_path, alert: 'No se pudo actualizar la solicitud'
    end
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(params[:request])

    @request.requester_email = current_user.email.strip.downcase
    @request.requested_at = Time.now
    @request.status = 'Pendiente'

    if @request.requester_email.strip.downcase == @request.approver_email.strip.downcase
      redirect_to new_request_path, alert: 'Debe escribir el nombre del Jefe Inmediato'
      return
    end
    if @request.approver_email.strip.downcase == ""
      redirect_to new_request_path, alert: 'Debe escribir el nombre del Jefe Inmediato'
      return
    end

    uploaded_io = params[:request][:letter_file]

    if uploaded_io
      @filename = Rails.root.join('public', 'uploads', uploaded_io.original_filename)

      # Upload file
      File.open(@filename, 'wb') do |file|
        file.write(uploaded_io.read)
      end

      @request.letter_file = uploaded_io.original_filename
    end


    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: 'Solicitud de vacaciones creada satisfactoriamente.' }
      else
        format.html { redirect_to new_request_path, notice: 'Error en la solicitud.'}
      end
    end
  end

  # Searches the names of the table named " leaders" and sends them, encoded with json
  def autocomplete
    @leader = Leaders.find(:all, :conditions => ["name like ?","%" + params[:term].upcase + "%"])
     render json: @leader 
  end

  def range_check
    date_begin = Time.parse params[:date_begin]
    date_end = Time.parse params[:date_end]

    date_begin = date_begin.strftime("%Y/%m/%d")
    date_end = date_end.strftime("%Y/%m/%d")
    @user_requests = Request.find :all, :conditions => ['status = "Aprobado" and requester_email = ?', current_user.email.downcase] 
    available_to_request = true
    if @user_requests
      @user_requests.each do |request|
        
        beginning = request.begin_at_approved.to_datetime.strftime("%Y/%m/%d")
        ending = request.end_at_approved.to_datetime.strftime("%Y/%m/%d")

        if beginning <= date_begin && date_begin <= ending 
            available_to_request = false
        else
          if beginning <= date_end && date_end <= ending
            available_to_request = false
          else
            if date_begin <= beginning && date_end >= ending
              available_to_request = false
            else
              available_to_request = true
            end
          end
        end
      end
    end

    respond_to do |format|
      format.json { render json: { :available_to_request => available_to_request} }
    end

  end


end
