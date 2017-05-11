module ApplicationHelper
  def nav_class(element)
    class_string = 'nav-link'

    navigation_elements = {
      imports: imports_path,
      sources: sources_path,
      tags: tags_path
    }

    class_string << ' active' if navigation_elements[element] == request.path
    class_string
  end

  def source_rank_options(source, type, action)
    case action
    when 'create'
      create_source_rank_options(type)
    when 'update'
      edit_source_rank_options(source, type)
    end
  end

  def edit_source_rank_options(selected_source, type)
    Source.all.map do |source|
      rank = source.rank_for(type)
      if source.name == selected_source.name
        ["#{rank}: current - #{source.name}", rank]
      else
        ["#{rank}: move here - #{source.name}", rank]
      end
    end.sort
  end

  def create_source_rank_options(type)
    options = Source.all.map do |source|
      rank = source.rank_for(type)
      ["#{rank}: insert above #{source.name}", rank]
    end.sort
    final_rank = options.count + 1
    final_option = ["#{final_rank}: add to end", final_rank]
    options + [final_option]
  end
end
