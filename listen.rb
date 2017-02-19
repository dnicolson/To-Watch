require_relative 'to_watch'
require 'listen'

Listen.to(File.expand_path('~/Downloads')) do |modified, added, _removed|
  ToWatch.add(added, type: :episodes)
  ToWatch.add(added, type: :movies)
  ToWatch.cleanup(modified, type: :episodes)
  ToWatch.cleanup(modified, type: :movies)
end.start

Listen.to(File.expand_path('~/Downloads/To Watch')) do |_modified, added, _removed|
  ToWatch.update_plex(added, type: :episodes)
end.start

Listen.to(File.expand_path('~/Movies')) do |_modified, added, _removed|
  ToWatch.update_plex(added, type: :movies)
end.start

sleep
