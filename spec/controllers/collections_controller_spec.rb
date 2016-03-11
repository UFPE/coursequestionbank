require 'spec_helper'

describe CollectionsController do
  
  describe 'update_multiple_tags' do
    
    it 'should add tags' do
      problem1 = Problem.create.id
      problem2 = Problem.create.id
      checked_hash = {problem1.to_s => "1", problem2.to_s => "1"}
      post :update_multiple_tags, :tag_names => "tag1, tag2", :checked_problems => checked_hash
      expect(Problem.find(problem1).tags.size).to eq(2)
      expect(Problem.find(problem2).tags.size).to eq(2)
    end
  end
end
