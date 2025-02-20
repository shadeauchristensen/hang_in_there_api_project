class Poster < ApplicationRecord
  def self.sort(direction)
    direction ||= :asc
    order(created_at: direction)
  end
end
