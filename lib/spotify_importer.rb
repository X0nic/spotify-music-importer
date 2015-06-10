class CollectionMatch
  def initialize(collection_record, spotify_match)
    @collection_record = collection_record
    @spotify_match = spotify_match
  end

  def full_match
    name_match && album_match
  end

  def name_match
    @collection_record.name == @spotify_match.name
  end

  def album_match
    @collection_record.album == @spotify_match.album
  end
end


class SpotifyMatch
  def initialize(results, options = {})
    @results = results
    @clean_album = options.delete(:clean_album) { false }
    @clean_track = options.delete(:clean_track) { false }
  end

  def found_match?
    @results['tracks']['items'].count > 0
  end

  def name
    if @clean_track
      TrackNameCleaner.new(@results["tracks"]["items"].first["name"]).clean
    else
      @results["tracks"]["items"].first["name"]
    end
  end

  def artist
    @results["tracks"]['items'].first['artists'].first['name']
  end

  def album
    if @clean_album
      AlbumNameCleaner.new(@results["tracks"]['items'].first['album']['name']).clean
    else
      @results["tracks"]['items'].first['album']['name']
    end
  end

  def id
    @results ["tracks"]["items"].first["id"]
  end

  def to_s
    "Name: #{name} Album: #{album} Artist: #{artist} id: #{id}"
  end
end

class AlbumNameCleaner
  def initialize(album_name)
    @album_name = album_name
  end

  def clean
    cleaned_album = @album_name

    extraneous_album_info.each do |album_info|
      cleaned_album = cleaned_album.gsub(album_info, '').strip
    end

    cleaned_album
  end

  def extraneous_album_info
    [
      '(Special Edition)',
      '(Deluxe Edition)',
      '(Deluxe Edition Remastered)',
      '(Remastered)',
      '(Canadian Version)',
      '(Non EU Version)',
      '(UK Version)',
      '(Brazilian Version)'
    ]
  end
end

class TrackNameCleaner
  def initialize(track_name)
    @track_name = track_name
  end

  def clean
    cleaned_track = @track_name

    extraneous_track_info.each do |track_info|
      cleaned_track = cleaned_track.gsub(track_info, '').strip
    end

    cleaned_track
  end

  def extraneous_track_info
    [
      '- Remastered',
      '- Single',
      '(Clean Album Version) (Clean)',
      '(Album Version)',
      '(Amended Album Version)',
      '(Explicit Album Version)'
    ]
  end
end

