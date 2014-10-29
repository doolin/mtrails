Rails.application.routes.draw do
  mount Subscribem::Engine, :at => "/subscribem"
end
