class Flickr
  def self.find(id)
    flickr.photos.getInfo(photo_id: id)
  end
end
