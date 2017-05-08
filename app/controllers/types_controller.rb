class TypesController < ApplicationController
  expose(:type_names) { Type.order(:name).pluck(:name) }
end
