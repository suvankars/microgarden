class AddUserRefRiders < ActiveRecord::Migration
  def change
    add_reference :riders, :user, index: true, foreign_key: true
  end
end
