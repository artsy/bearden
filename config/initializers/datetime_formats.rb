{
  export_folder: '%Y%m%d%H%M%S',
  list_page: '%d %b %Y, %H:%M:%S'
}.each do |name, format|
  Time::DATE_FORMATS[name] = format
end
