class Lodge::LodgeController < ApplicationController
  layout 'lodge'
  before_filter :authenticate_admin!  
end