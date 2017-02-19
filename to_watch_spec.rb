require './to_watch'

RSpec.describe ToWatch do
  describe '.add' do
    before do
      allow(File).to receive(:rename)
    end

    describe 'an episode' do
      let(:files) { ['Its.Always.Sunny.in.Philadelphia.S12E01.720p.HDTV.x264-AVS.mkv'] }

      it 'moves to the correct location while Chrome is downloading the file' do
        expect(File).to receive(:rename).with(files[0], File.expand_path(File.join('~/Downloads/To Watch', files[0])))
        files.map! { |f| f << '.crdownload' }
        ToWatch.add(files, type: :episodes)
      end
    end

    describe 'a movie' do
      let(:files) { ['The.Shawshank.Redemption.1994.1080p.x264.YIFY.mp4'] }

      it 'moves to the correct location while Chrome is downloading the file' do
        expect(File).to receive(:rename).with(files[0], File.expand_path(File.join('~/Movies', files[0])))
        files.map! { |f| f << '.crdownload' }
        ToWatch.add(files, type: :movies)
      end
    end
  end

  describe '.cleanup' do
    before do
      allow(File).to receive(:delete)
      allow(File).to receive(:stat).and_return double(size: 0)
    end

    describe 'an episode' do
      let(:files) { ['~/Downloads/To Watch/Its.Always.Sunny.in.Philadelphia.S12E01.720p.HDTV.x264-AVS.mkv'] }

      it 'removes the temp file' do
        expect(File).to receive(:delete).with(File.join(File.expand_path('~/Downloads'), File.basename(files[0])))
        ToWatch.cleanup(files, type: :episodes)
      end
    end

    describe 'a movie' do
      let(:files) { ['~/Movies/The.Shawshank.Redemption.1994.1080p.x264.YIFY.mp4'] }

      it 'removes the temp file' do
        expect(File).to receive(:delete).with(File.join(File.expand_path('~/Downloads'), File.basename(files[0])))
        ToWatch.cleanup(files, type: :movies)
      end
    end
  end

  describe '.update_plex' do
    before do
      allow(ToWatch).to receive(:system)
    end

    describe 'an episode' do
      let(:files) { ['Its.Always.Sunny.in.Philadelphia.S12E01.720p.HDTV.x264-AVS.mkv'] }

      it 'updates the episode library' do
        expect(ToWatch).to receive(:system).with(/Plex Media Scanner.*?--scan --refresh --section 1$/)
        ToWatch.update_plex(files, type: :episodes)
      end
    end

    describe 'a movie' do
      let(:files) { ['~/Movies/The.Shawshank.Redemption.1994.1080p.x264.YIFY.mp4'] }

      it 'updates the movie library' do
        expect(ToWatch).to receive(:system).with(/Plex Media Scanner.*?--scan --refresh --section 4$/)
        ToWatch.update_plex(files, type: :movies)
      end
    end
  end
end
