class Admin::BaseController < ApplicationController
  http_basic_authenticate_with name: "etb", password: "wowpac"
  layout "admin"
end
