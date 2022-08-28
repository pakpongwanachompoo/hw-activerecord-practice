require 'sqlite3'
require 'active_record'
require 'byebug'


ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    users = Customer.where(first: 'Candice').order(create_at: :desc)
    return users
  end

  def self.with_valid_email
    email = Customer.where('email LIKE ?','%@%')
    return email
  end

  def self.with_dot_org_email
    dot_org = Customer.where('email LIKE ?','%.org%')
    return dot_org
  end

  def self.with_invalid_email
    invalid_email = Customer.where.not('email LIKE ?','%@%')
    return invalid_email
  end

  def self.with_blank_email
    blank =  Customer.where(email: nil).order(create_at: :desc)
    return blank
  end

  def self.born_before_1980
    bornbefore= Customer.where("birthdate < ?",'1980-01-01')
    return bornbefore
  end

  def self.with_valid_email_and_born_before_1980
    validemailbefore1980 = Customer.where("birthdate < ?",'1980-01-01').where('email LIKE ?','%@%')
    return validemailbefore1980
  end

  def self.last_names_starting_with_b
    laststart = Customer.where('last LIKE ?','B%').order(birthdate: :asc)
  return laststart
  end

  ## No Need where
  def self.twenty_youngest
    twentyyoung = Customer.order(birthdate: :desc).limit(20)
    return twentyyoung
  end

  ## Update
  def self.update_gussie_murray_birthdate
    updatebirth = Customer.find_by(:first => 'Gussie').update(birthdate: '2004-2-8')
  end

  def self.change_all_invalid_emails_to_blank
    changeinvalid = Customer.where.not('email LIKE ?','%@%').update(email: nil)
  end

  def self.delete_meggie_herman
    delete_meggie = Customer.find_by(:first => 'Meggie', :last => 'Herman').destroy
  end

  def self.delete_everyone_born_before_1978
    deletebornbefore= Customer.where("birthdate < ?",'1978-01-01').destroy_all
  end
  
end
