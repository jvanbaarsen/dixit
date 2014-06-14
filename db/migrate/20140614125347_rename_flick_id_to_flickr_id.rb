class RenameFlickIdToFlickrId < ActiveRecord::Migration
  def change
    rename_column :submitted_pictures, :flick_id, :flickr_id
  end
end
