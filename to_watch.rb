class ToWatch
  CONFIG = {
    episodes: {
      match_temp: /.*?S\d\dE\d\d.*\.crdownload$/i,
      match:      /.*?S\d\dE\d\d.*/i,
      path:       '~/Downloads/To Watch',
      plex_id:    1
    },
    movies:   {
      match_temp: /.*\d{4}\..*(mp4|mkv|avi|mov)\.crdownload$/i,
      match:      /.*\d{4}\..*(mp4|mkv|avi|mov)$/i,
      path:       '~/Movies',
      plex_id:    4
    }
  }.freeze

  class << self
    def add(files, options = {})
      return unless CONFIG.keys.include? options[:type]
      match_temp, path = CONFIG[options[:type]].values_at(:match_temp, :path)

      files.select { |f| f =~ match_temp }.each do |file|
        new_file = File.basename(file).sub(File.extname(file), '')
        new_path = File.join(path, new_file)
        File.rename(file, File.expand_path(new_path))
      end
    end

    def cleanup(files, options = {})
      return unless CONFIG.keys.include? options[:type]
      match = CONFIG[options[:type]][:match]

      files.select { |f| f =~ match }.each do |file|
        old_file = File.join(File.expand_path('~/Downloads'), File.basename(file))
        File.delete(old_file) if File.stat(old_file).size.zero?
      end
    end

    def update_plex(files, options = {})
      return unless CONFIG.keys.include? options[:type]
      match, plex_id = CONFIG[options[:type]].values_at(:match, :plex_id)

      files.select { |f| f =~ match }.each do
        system "'/Applications/Plex Media Server.app/Contents/MacOS/Plex Media Scanner' --scan --refresh --section #{plex_id}"
      end
    end
  end
end
