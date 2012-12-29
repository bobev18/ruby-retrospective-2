Song = Struct.new(:name, :artist, :album)

class Criteria
  attr_accessor :condition

  def initialize(&block)
    @condition = block
  end

  def self.name(predicament)
    Criteria.new { |song| song.name == predicament }
  end

  def self.artist(predicament)
    Criteria.new { |song| song.artist == predicament }
  end

  def self.album(predicament)
    Criteria.new { |song| song.album == predicament }
  end

  def &(other)
    Criteria.new { |song| @condition.call(song) and other.condition.call(song) }
  end

  def |(other)
    Criteria.new { |song| @condition.call(song) or other.condition.call(song) }
  end

  def !
    Criteria.new { |song| not @condition.call(song) }
  end

  def matches?(song)
    condition.call(song)
  end
end

class Collection
  include Enumerable
  attr_accessor :songs

  def initialize(data)
    @songs = data
  end

  def each
    @songs.each { |item| yield item }
  end

  def self.parse(data)
    Collection.new data.split("\n\n").map { |song| Song.new(*song.split("\n")) }
  end

  def filter(conditions)
    Collection.new @songs.select { |song| conditions.matches?(song) }
  end

  def adjoin(filtered)
    Collection.new (@songs | filtered.songs)
  end

  def artists
    @songs.collect { |song| song.artist }.uniq
  end

  def albums
    @songs.collect { |song| song.album }.uniq
  end

  def names
    @songs.collect { |song| song.name }.uniq
  end
end


