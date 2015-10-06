class Talk < ActiveResource::Base
  self.site = "https://cfp.openfest.org/api/conferences/2"
  self.element_name = "event"
end
