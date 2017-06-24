describe Fastlane::Helper::VerifyIpaHelper do
  describe 'helper' do
    before(:all) do
      @tmpdir = Dir.mktmpdir
      @app_path = Fastlane::Helper::VerifyIpaHelper.app_path('./spec/fixtures/verify_ipa_files/foo.ipa', @tmpdir)
    end

    after(:all) do
      FileUtils.remove_entry @tmpdir
    end

    it 'should find app path' do
      expect(@app_path).to eq("#{@tmpdir}/Payload/foo.app")
    end

    it 'should find appex path' do
      appex_path = Fastlane::Helper::VerifyIpaHelper.appex_path(@app_path, 'My Widget')
      expect(appex_path).to eq("#{@app_path}/PlugIns/My Widget.appex")
    end

    it 'should raise user_error if fails to find appex path' do
      expect(Fastlane::UI).to receive(:user_error!).with("Unable to find '#{@app_path}/PlugIns/NoSuchFile.appex'.")
      appex_path = Fastlane::Helper::VerifyIpaHelper.appex_path(@app_path, 'NoSuchFile')
    end
  end
end
