ThinkingSphinx::Index.define :user, :with => :real_time do
  # fields
  indexes name, :sortable => true
  indexes photo_comments
  indexes photo_tags

  # attributes
  has created_at, :type => :timestamp
  has height, weight, :type => :integer
  has sex, :type => :string
  has birth, :type => :timestamp

end