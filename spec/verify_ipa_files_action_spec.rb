describe Fastlane::Actions::VerifyIpaFilesAction do
  describe '#run' do
    it 'should find app dir inside of ipa (https://github.com/dyang/verify_ipa/issues/1)' do
      Fastlane::Actions::VerifyIpaFilesAction.run(
        { ipa_path: './spec/fixtures/verify_ipa_files/foo.ipa',
          blacklist: ['*.sh'] }
      )
    end
  end

  describe '#verify_files' do
    it 'raises user_error if files in blacklist exists in ipa' do
      fixture_path = './spec/fixtures/verify_ipa_files'
      expect(Fastlane::UI).to receive(:user_error!).with("Found files on the blacklist: [\"offline_data.json\", \"sensitive.json\", \"top_secret.json\"]")

      Fastlane::Actions::VerifyIpaFilesAction.verify_files(
        { blacklist: ['*.json'] },
        fixture_path
      )
    end

    it 'raises user_error if multiple blacklist patterns specified as {a,b} exist in ipa' do
      fixture_path = './spec/fixtures/verify_ipa_files'
      expect(Fastlane::UI).to receive(:user_error!).with("Found files on the blacklist: [\"offline_data.json\", \"sensitive.json\", \"top_secret.json\", \"build.sh\"]")

      Fastlane::Actions::VerifyIpaFilesAction.verify_files(
        { blacklist: ['*.{json,sh}'] },
        fixture_path
      )
    end

    it 'raises user_error if multiple blacklist patterns specified as array exist in ipa' do
      fixture_path = './spec/fixtures/verify_ipa_files'
      expect(Fastlane::UI).to receive(:user_error!).with("Found files on the blacklist: [\"offline_data.json\", \"sensitive.json\", \"top_secret.json\", \"build.sh\"]")

      Fastlane::Actions::VerifyIpaFilesAction.verify_files(
        { blacklist: ['*.json', '*.sh'] },
        fixture_path
      )
    end

    it 'does not throw user_error for files on the whitelist' do
      fixture_path = './spec/fixtures/verify_ipa_files'
      expect(Fastlane::UI).to receive(:user_error!).with("Found files on the blacklist: [\"sensitive.json\", \"top_secret.json\"]")

      Fastlane::Actions::VerifyIpaFilesAction.verify_files(
        { blacklist: ['*.json'], whitelist: ['offline_data.json'] },
        fixture_path
      )
    end

    it 'does not throw user_error if no files on blacklist are found in ipa' do
      fixture_path = './spec/fixtures/verify_ipa_files'

      Fastlane::Actions::VerifyIpaFilesAction.verify_files(
        { blacklist: ['*.rb'] },
        fixture_path
      )
    end
  end
end
