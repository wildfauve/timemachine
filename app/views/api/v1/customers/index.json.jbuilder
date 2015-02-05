json.kind "customers"
json.status "ok"
json.customers @customers do |cust|
  json.name cust.name
  json.projects cust.projects do |proj|
    json.name proj.name
  end
end