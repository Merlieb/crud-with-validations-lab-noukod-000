require 'time'

class ReleaseYearValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
  
    if (record.released)
      if(value.nil?)
        record.errors.add(:release_year,"Error")
      end
      if(value.to_i>Time.now.year.to_i)
        record.errors.add(:release_year,"Error")
      end
    else
      if(!value.nil?)
        record.errors.add(:release_year,"Error")
      end
    end
 end
end

class TitleValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    songs_with_same_title=Song.where("title = :title AND release_year = :release_year AND artist_name = :artist_name",{title:value,release_year:record.release_year,artist_name:record.artist_name})


    unless songs_with_same_title.count==0
      record.errors[:title] << "The same song cannot be released twice in the same year"
    
    end
  end
end


class Song < ActiveRecord::Base
  validates :title,presence:true,title:true
  validates :release_year,release_year:true
  validates :released,inclusion:{in:[true,false]}

