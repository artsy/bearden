class TagsController < AdminController
  expose(:tag_names) { Tag.order(:name).pluck(:name) }
end
