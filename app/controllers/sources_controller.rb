class SourcesController < ApplicationController
  expose(:sources) { Source.order(:name) }
end
