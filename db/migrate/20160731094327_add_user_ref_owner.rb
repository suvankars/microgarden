class AddUserRefOwner < ActiveRecord::Migration
  def change
    add_reference :owners, :user, index: true, foreign_key: true
  end
end
