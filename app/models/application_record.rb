class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.all_paginated(limit, offset)
    all.limit(limit).offset(offset)
  end
end
