json.employees employees do |emp|
  json.name emp.name
  json.billable_u emp.billable_u
  json.summ_refresh_date emp.summ_refresh_date
  json.projects emp.projects do |proj|
    json.project_id proj.id.to_s
  end
  json.days emp.days do |day|
    json.date day.date
    json.entries day.entries do |ent|
      json.hours ent.hours
      json.project_id ent.project.to_s
      json.note ent.note
      json.costcodeentries ent.costcodeentries do |cce|
        json.costcode_id cce.costcode.to_s
        json.hours cce.hours.to_s
      end
    end
  end
end