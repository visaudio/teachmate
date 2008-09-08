class Subscription < ActiveRecord::Base

  validates_uniqueness_of :search_query_id, :scope => [:user_id]

  belongs_to :user
  belongs_to :search_query

  class <<self
    def find_for_user(user_id)
      
      subscriptions = User.find(user_id).subscriptions
      queries_ids = subscriptions.map {|s| s.search_query_id} 
      queries = SearchQuery.find(:all, :conditions => ['id in (?)', queries_ids])
      
      result = []
      subscriptions.each do |s|
        
        query = nil
        queries.each do |q|
          query = q if q.id == s.search_query_id
        end

        result.push(
          {
            :learn_string => query.learn_string,
            :teach_string => query.teach_string,
            :element => s
          }
        ) if query
      end
      result 
    
    end
  end
end
