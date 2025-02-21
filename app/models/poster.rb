class Poster < ApplicationRecord
  def self.sort(direction)
    direction ||= :asc
    order(created_at: direction)
  end

  def self.filter(params)
    if params[:name].present?
      where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%")
    elsif params[:min_price].present?
      where("price >= ?", params[:min_price].to_f)
    else
      where("price <= ?", params[:max_price].to_f)
    end
  end
end
