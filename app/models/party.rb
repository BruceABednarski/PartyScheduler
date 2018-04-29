#
# Table Schema
# ------------
# id            - int(11)      - default NULL
# host_name     - varchar(255) - default NULL
# host_email    - varchar(255) - default NULL
# numgsts       - int(11)      - default NULL
# guest_names   - text         - default NULL
# venue         - varchar(255) - default NULL
# location      - varchar(255) - default NULL
# theme         - varchar(255) - default NULL
# when          - datetime     - default NULL
# when_its_over - datetime     - default NULL
# descript      - text         - default NULL
#
class Party < ApplicationRecord

  validate :validations

  def validations
    if self.host_name.length>255 || self.host_email.length>255 || self.venue.length>255 || self.location.size>255 || self.theme.size>255
      errors.add(:base,"Input was too long.")
      self.descript = "Input was too long."
    end
    # ruby doesn't like us using when as column name for some reason
    if self.when > self.when_its_over
      errors.add(:base,"Incorrect party time.")
       self.descript = "Incorrect party time."
    end
     if self.numgsts.nil?
      self.numgsts = 0
    end
    if self.venue.length > 0 && self.location.length < 0
      errors.add(:location,"Where is the party?")
       self.descript = "Where is the party?"
    end
   if  self.guest_names.to_s.split(',').size != self.numgsts
      errors.add(:guest_names,"Missing guest name")
       self.descript = "Missing guest name"
    end
   end

  def after_save
    # clean "Harry S. Truman" guest name to "Harry S._Truman"
    # clean "Roger      Rabbit" guest name to "Roger Rabbit"
    gnames = []
    self.guest_names.to_s.split(',').each do |g|
      g.squeeze!
      names=g.split(' ')
      gnames << "#{names[0]} #{names[1..-1].join('_')}"
    end
    self.guest_names = gnames
    save!
  end

end
