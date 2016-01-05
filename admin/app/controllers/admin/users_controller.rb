require_dependency "admin/application_controller"

module Admin
  class UsersController < ApplicationController
    include Godmin::Resources::ResourceController
  end
end