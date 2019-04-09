module Namecheap::Domain
  include Namecheap::API
  extend self

  def check(domains)
    domains = domains.is_a?(Array) ? domains.join(',') : domains

    get 'domains.check', DomainList: domains
  end

  def create(domain, registrant_contact, tech_contact = nil, admin_contact = nil,
             aux_contact = nil, billing_contact = nil, years = 1,
             promo_code = nil, nameserver = nil, free_whois = true,
             idn_code = nil, is_premium_domain = false)
    params = { DomainName: domain, Years: years }
    params.merge!(PromotionCode: promo_code) unless promo_code.nil?
    params.merge!(IdnCode: idn_code) unless idn_code.nil?
    params.merge!(AddFreeWhoisguard: (free_whois ? 'yes' : 'no')) unless free_whois.nil?
    params.merge!(WGEnabled: (free_whois ? 'yes' : 'no')) unless free_whois.nil?
    params.merge!(IsPremiumDomain: is_premium_domain)

    params.merge!(registrant_contact.to_request_params('Registrant'))
    params.merge!((tech_contact || registrant_contact).to_request_params('Tech'))
    params.merge!((admin_contact || registrant_contact).to_request_params('Admin'))
    params.merge!((aux_contact || registrant_contact).to_request_params('AuxBilling'))
    params.merge!((billing_contact || registrant_contact).to_request_params('Billing'))

    post 'domains.create', params
  end

  def get_contacts(domain)
    get 'domains.getContacts', DomainName: domain
  end

  def get_info(domain)
    get 'domains.getInfo', DomainName: domain
  end

  # List domains with pagination, searching, sorting, and type
  # list_type defaults to ALL
  #     valid ALL, EXPIRING, or EXPIRED
  # sort_by doesnt have a Namecheap default, but we default to NAME
  #     valid NAME, NAME_DESC, EXPIREDATE, EXPIREDATE_DESC, CREATEDATE, CREATEDATE_DESC
  def get_list(page=1,per_page=20,search=nil,sort_by="NAME",list_type="ALL")
    params = {
      ListType: list_type,
      Page: page,
      PageSize: per_page,
      SortBy: sort_by,
    }
    params.merge!(SearchTerm: search) if ! search.blank?
    get 'domains.getList', params
  end

  def get_registrar_lock(domain)
    get 'domains.getRegistrarLock', DomainName: domain
  end

  def get_tld_list
    get 'domains.getTldList'
  end

  def reactivate(domain)
    get 'domains.reactivate', DomainName: domain
  end

  def renew(domain, years = 1, promo_code = nil)
    params = { DomainName: domain, Years: years }
    params.merge!(PromotionCode: promo_code) unless promo_code.nil?

    get 'domains.renew', params
  end

  def set_contacts(*)
    raise 'implementation needed'
  end

  def set_registrar_lock(domain, lock)
    raise "Lock value must be 'LOCK' or 'UNLOCK'" unless lock == 'LOCK' || lock == 'UNLOCK'

    params = { DomainName: domain, LockAction: lock }

    get 'domains.setRegistrarLock', params
  end
end
