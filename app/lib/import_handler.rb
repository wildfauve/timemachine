class ImportHandler
  
  def initialize(path)
    @path = path
    self
  end
  
=begin
"employees": [
    {
        "billable_u": 94.23214285714285,
        "days": [
                {
                    "date": "2014-05-29",
                    "entries": [
                        {
                            "costcodeentries": [],
                            "hours": 4.0,
                            "note": null,
                            "project_id": "51f05fb5e4df1c834a000008"
                        },
                        {
                            "costcodeentries": [
                                {
                                    "costcode_id": "53215816f3654e73bf00000c",
                                    "hours": 1.0
                                },
                                {
                                    "costcode_id": "537e94b4f3654eaef1000001",
                                    "hours": 3.0
                                }
                            ],
                            "hours": 4.0,
                            "note": null,
                            "project_id": "5215303ee4df1c285a000001"
                        }
                    ]
                },
        "name": "Col",
        "projects": [
        {
            "project_id": "51f05fb5e4df1c834a000008"
        },
        {
            "project_id": "51f05fcae4df1c9cd200000b"

=end
  
  def parse
    json = ActiveSupport::JSON.decode(File.open(@path).read)
    json["employees"].each do |emp|
      e = create_employee(emp)
      emp["projects"].each do |proj|
        e.update_it(emp_update_msg(emp: e, proj: proj))
      end
      emp["days"].each do |day|
        day["entries"].each do |ent|
          #add_time_msg(day: day, ent: ent)
          e.add_time(add_time_msg(day: day, ent: ent))
        end
      end
    end
  end


  def create_employee(emp)
    e = Employee.where(name: emp["name"]).first
    if e
      e
    else
      e = Employee.create_it({name: emp["name"]})
      e
    end
  end
  
=begin
 "project"=>
  #<Project _id: 540530ecf3654ec0e9000005, created_at: 2014-09-02 02:52:28 UTC, updated_at: 2014-09-02 02:52:41 UTC, name: "EA Roadmap", desc: "", billable: true, customer_id: BSON::ObjectId('540530d5f3654e2747000004'), employee_ids: [BSON::ObjectId('51efb2a5e4df1c5434000001')]>,
 "date"=>"2014-12-01",
  "costcodes"=>
    {"532157f7f3654e73bf00000a"=>"",
     "53215807f3654e73bf00000b"=>"",
     "53215816f3654e73bf00000c"=>"1.0",
     "537e94b4f3654eaef1000001"=>"3.0",
     "537e94cff3654eaef1000002"=>""},  
 "custom_num"=>"2.0",
 "fill-value"=>"",
 "note"=>"",
 "employee_id"=>"51efb2a5e4df1c5434000001",
 "id"=>"540530ecf3654ec0e9000005"}
=end 
  def add_time_msg(day: nil, ent: nil)
    msg = {}
    msg[:date] = day["date"]
    msg[:project] = Project.find(ent["project_id"])
    msg[:custom_num] = ent["hours"]
    msg[:costcodes] = {}
    ent["costcodeentries"].each {|cce| msg[:costcodes][cce["costcode_id"]] = cce["hours"]}
    msg
  end
  
# "employee"=>{"name"=>"Col"}, "project"=>"53179af0f3654eb0ee000003",  
  def emp_update_msg(emp: nil, proj: nil)
    msg = {}
    msg[:employee] = {name: emp.name}
    msg[:project] = proj["project_id"]
    msg
  end
    

end
    