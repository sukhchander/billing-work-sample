module Admin
  class UserService
    include Godmin::Resources::ResourceService

    attrs_for_index
    attrs_for_show
    attrs_for_form
  end
end