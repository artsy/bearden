class TagsController < ApplicationController
  expose(:tag_names) { Tag.order(:name).pluck(:name) }
end
