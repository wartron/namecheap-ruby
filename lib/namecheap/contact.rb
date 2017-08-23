module Namecheap
  class Contact
    attr_accessor :first_name, :last_name, :address1, :address2,
                  :city, :state_province, :state_province_choice,
                  :postal_code, :country, :phone, :email_address,
                  :organization_name, :job_title, :phone_ext, :fax

    def to_request_params(prefix = nil)
      params = {
        FirstName: first_name,
        LastName: last_name,
        Address1: address1,
        City: city,
        StateProvince: state_province,
        PostalCode: postal_code,
        Country: country,
        Phone: phone,
        EmailAddress: email_address
      }
      params.merge!(OrganizationName: organization_name) unless organization_name.nil?
      params.merge!(Address2: address2) unless address2.nil?
      params.merge!(JobTitle: job_title) unless job_title.nil?
      params.merge!(StateProvinceChoice: state_province_choice) unless state_province_choice.nil?
      params.merge!(PhoneExt: phone_ext) unless phone_ext.nil?
      params.merge!(Fax: fax) unless fax.nil?

      return params if prefix.nil?

      Hash[params.map { |k,v| ["#{prefix}#{k}".to_sym,v] }]
    end
  end
end
