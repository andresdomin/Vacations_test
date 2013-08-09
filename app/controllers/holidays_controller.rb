class HolidaysController < ApplicationController
  before_filter :authenticate_user!

  # GET /holidays
  # GET /holidays.json
  def index
    @holidays = Holiday.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @holidays }
    end
  end

  # GET /holidays/1
  # GET /holidays/1.json
  def show
    @holiday = Holiday.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @holiday }
    end
  end

  # GET /holidays/new
  # GET /holidays/new.json
  def new
    @holiday = Holiday.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @holiday }
    end
  end

  # GET /holidays/1/edit
  def edit
    @holiday = Holiday.find(params[:id])
  end

  # POST /holidays
  # POST /holidays.json
  def create
    @holiday = Holiday.new(params[:holiday])

    respond_to do |format|
      if @holiday.save
        format.html { redirect_to @holiday, notice: 'Holiday was successfully created.' }
        format.json { render json: @holiday, status: :created, location: @holiday }
      else
        format.html { render action: "new" }
        format.json { render json: @holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /holidays/1
  # PUT /holidays/1.json
  def update
    @holiday = Holiday.find(params[:id])

    respond_to do |format|
      if @holiday.update_attributes(params[:holiday])
        format.html { redirect_to @holiday, notice: 'Holiday was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /holidays/1
  # DELETE /holidays/1.json
  def destroy
    @holiday = Holiday.find(params[:id])
    @holiday.destroy

    respond_to do |format|
      format.html { redirect_to holidays_url }
      format.json { head :no_content }
    end
  end
  
  def calculate_days
    date_begin = Time.parse params[:date_begin]
    date_end = Time.parse params[:date_end]
    
    # Count business days
    days = business_days_between(date_begin, date_end)
    
    if date_begin.thursday? or date_begin.friday?
      days = days - 1
    end
    if date_begin.thursday?
        next_saturday = date_begin + 2.day
    elsif date_begin.friday?
        next_saturday = date_begin + 1.day
    end

    if next_saturday
       saturday_holiday = Holiday.find_by_holiday_at(next_saturday.strftime('%Y-%m-%d')) 
    end

    if saturday_holiday
      deduct_day = true
    else
      deduct_day = false
    end

    # calculates return to office date
    back_to_office = return_to_office(date_begin, date_end)
    
    # Count holidays
    holidays = Holiday.count(:all, :conditions => ["holiday_at BETWEEN ? AND ?", date_begin, date_end])
    




    respond_to do |format|
      format.json { render json: { :days => days, :holidays => holidays, :back_to_office => back_to_office, :deduct_day => deduct_day} }
    end
  end
  
  private
  
  def business_days_between(date1, date2)
    business_days = 0
    date = date2
    while date > date1
     business_days = business_days + 1 unless date.sunday?
     date = date - 1.day
    end
    business_days
  end

  def return_to_office(date_begin,date_end)
    if date_end.friday?
      back_to_office = date_end + 3.days
    else
      if date_end.saturday?
          back_to_office = date_end + 2.days
      else
        back_to_office = date_end + 1.days
      end
    end
    date_to_query = back_to_office.strftime("%Y/%m/%d")
    is_holiday = true
    while is_holiday
      query = Holiday.where(:holiday_at => date_to_query, :country => "Colombia")
      if query==[]
          is_holiday = false
      else
        back_to_office = back_to_office + 1.day
        date_to_query = back_to_office.strftime("%Y/%m/%d")
      end
    end
    back_to_office = back_to_office.strftime("%Y/%m/%d")
  end
end
