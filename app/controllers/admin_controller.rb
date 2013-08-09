class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter do
    unless current_user && current_user.admin?
      flash[:alert] = 'No tiene permisos para ver este recurso'
      redirect_to :root
    end
  end

  # shows the index of the activity
  def leaders_index
  end

# shows the page to upload the .xls
  def leaders
  end

  # Shows a preview of the uploaded file before it is saved
  def show
    uploaded_io = params[:leaders]

    if uploaded_io
      @filename = Rails.root.join('public', 'uploads', uploaded_io.original_filename)

      # Upload file
      File.open(@filename, 'wb') do |file|
        file.write(uploaded_io.read)
      end

      @leaders = get_leaders(@filename)
    else
      redirect_to admin_leaders_path
    end
  end

# Saves the data that was taken from excel
  def save_leaders
    filename = params[:filename]
    if filename
      leaders = get_leaders(filename)
      leaders.each do |leader|
        l = Leaders.find_by_identification(leader.identification)
        if l
          l.update_attributes(:name => leader.name,:city => leader.city,:company => leader.company,:position => leader.position,:leader_id => leader.leader_id)
        else
          leader.save
        end
      end

      redirect_to admin_path, :notice => 'Base de datos guardada exitosamente'
    else
      redirect_to admin_leaders_path
    end
  end



  def index
  end

  def database
  end

  def upload
    uploaded_io = params[:database]

    if uploaded_io
      @filename = Rails.root.join('public', 'uploads', uploaded_io.original_filename)

      # Upload file
      File.open(@filename, 'wb') do |file|
        file.write(uploaded_io.read)
      end

      @vacations = get_vacations(@filename)
    else
      redirect_to admin_database_path
    end
  end

  def save
    filename = params[:filename]
    if filename
      vacations = get_vacations(filename)
      vacations.each do |vacation|
        v = Vacations.find_by_identification(vacation.identification)
        if v
          v.update_attributes(:available_days => vacation.available_days) if v.available_days != vacation.available_days
        else
          vacation.save
        end
      end

      redirect_to admin_path, :notice => 'Base de datos guardada exitosamente'
    else
      redirect_to admin_database_path
    end
  end

  private

  def get_vacations(filename)
    # Process file
    vacations = []

    book = Spreadsheet.open(filename, 'rb')
    sheet = book.worksheet 0
    sheet.each 1 do |row|
      vacation = Vacations.new
      vacation.identification = row[0]
      vacation.company = row[1]
      vacation.fullname = row[2]
      vacation.entry_at = row[4]
      vacation.available_days = row[8]
      vacations << vacation
    end

    vacations
  end

# Saves in a array the data
    def get_leaders(filename)
    # Process file
   leaders = []

    book = Spreadsheet.open(filename, 'rb')
    sheet = book.worksheet 0
    sheet.each 2 do |row|
      leader = Leaders.new
      leader.identification = row[0]
      leader.name = row[1]
      leader.email = row[2]
      leader.city = row[3]
      leader.company = row[4]
      leader.position = row[5]
      leader.leader_id = row[6]
      leaders << leader
    end

    leaders
  end

end
