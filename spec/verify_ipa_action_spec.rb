describe Fastlane::Actions::VerifyIpaAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The verify_ipa plugin is working!")

      Fastlane::Actions::VerifyIpaAction.run(nil)
    end
  end
end
