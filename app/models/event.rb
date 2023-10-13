class Event < ApplicationRecord
    has_many :attendeeinfos
    accepts_nested_attributes_for :attendeeinfos
    
    
end
