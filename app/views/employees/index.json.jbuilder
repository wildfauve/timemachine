json.status "ok"
json.employees @employees do |e|
  json.name e.name
  json.projects e.projects do |p|
    json.proj p.name
  end
end