class TypesController < AdminController
  expose(:type_names) { Type.order(:name).pluck(:name) }
end
