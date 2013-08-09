class Users::SessionsController < Devise::SessionsController

  def create
    domains = Array.new
    domains = ['intergrupo.com','igapps.co']

    # Authenticate via IG WebService
    user = params[:user]
    email = user[:email]
    email_domain = email.split('@')[1]
    domain_exist = domains.include?(email_domain)
    if domain_exist
        password = user[:password]
        result = authenticate(email, password)
        # Create or update the user in the database
        unless result == 'Error'
          identification = result.split("-")[0]
          name = result.split("-")[1]
          stored_user = User.find_by_email(email)
          if stored_user
            stored_user.update_attribute(:password, password)
          else
            User.create(:display_name=> name, :email => email, :password => password, :identification => identification)
          end
        end
        
        # Do devise normal authentication
        super
    else

      super
    end
  end
  
  
  private
  
  def authenticate(email, password)
    begin
      username = email.split('@')[0]
      
      client = Savon::Client.new do
        wsdl.document = "http://serviceauthentication.intergrupo.com/Service1.svc?wsdl"
        wsdl.namespace = "http://tempuri.org/"
      end
      client.http.read_timeout = 20
      client.http.open_timeout = 20
      
      response = client.request :wsdl, :validar_usuario do
          soap.body = { 'wsdl:usuario' => username, 'wsdl:clave' => password }
      end
      
      result = response.to_hash[:validar_usuario_response][:validar_usuario_result]
    rescue Timeout::Error
      "Error"
    rescue Errno::ETIMEDOUT
      "Error"
    rescue Savon::Error
      "Error"
    end
  end
end
