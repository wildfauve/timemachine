class Projectstate
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :viewable, :type => Boolean
  field :project, :type => Moped::BSON::ObjectId
  
  embedded_in :projectstate, :inverse_of => :projectstates

  def mod(params)
    params[:view_state] == "hide" ? self.viewable = false : self.viewable = true
  end

end