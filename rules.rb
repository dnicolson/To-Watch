require_relative 'to_watch'

Maid.rules do
  watch '~/Downloads' do
    rule 'Move downloading episodes and movies' do |modified, added, _removed|
      ToWatch.add(added, type: :episodes)
      ToWatch.add(added, type: :movies)
      ToWatch.cleanup(modified, type: :episodes)
      ToWatch.cleanup(modified, type: :movies)
    end
  end

  watch '~/Downloads/To Watch' do
    rule 'Update Plex for episodes' do |_modified, added, _removed|
      ToWatch.update_plex(added, type: :episodes)
    end
  end

  watch '~/Movies' do
    rule 'Update Plex for movies' do |_modified, added, _removed|
      ToWatch.update_plex(added, type: :movies)
    end
  end
end
