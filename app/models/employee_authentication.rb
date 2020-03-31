module EmployeeAuthentication 

    # For authentication
    ROLES_LIST = [['Employee', 'employee'],['Manager', 'manager'],['Administrator', 'admin']].freeze

    def role?(authorized_role)
      return false if role.nil?
      role.downcase.to_sym == authorized_role
    end
    
    # login by username
    def Employee.authenticate(username, password)
      find_by_username(username).try(:authenticate, password)
    end 

end