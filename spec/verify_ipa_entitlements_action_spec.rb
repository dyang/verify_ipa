describe Fastlane::Actions::VerifyIpaEntitlementsAction do
  describe '#verify_entitlements' do
    entitlements = Plist.parse_xml"<dict>
                <key>keychain-access-groups</key>
                <array>
                        <string>MZ6ZTY3EA6.*</string>
                </array>
                <key>get-task-allow</key>
                <false/>
                <key>application-identifier</key>
                <string>MZ6ZTY3EA6.com.apple.*</string>
                <key>com.apple.developer.team-identifier</key>
                <string>MZ6ZTY3EA6</string>
        </dict>"

    it 'raises user_error if application identifier does not match' do
      expect(Fastlane::UI).to receive(:user_error!).with("Mismatched application_identifier. Expected: 'MZ6ZTY3EA6.com.apple.myapp'; Found: 'MZ6ZTY3EA6.com.apple.*'")

      Fastlane::Actions::VerifyIpaEntitlementsAction.verify_entitlements(
        { application_identifier: 'MZ6ZTY3EA6.com.apple.myapp' },
        entitlements
      )
    end

    it 'raises user_error if team identifier does not match' do
      expect(Fastlane::UI).to receive(:user_error!).with("Mismatched team_identifier. Expected: 'MZ6ZTY3EA7'; Found: 'MZ6ZTY3EA6'")

      Fastlane::Actions::VerifyIpaEntitlementsAction.verify_entitlements(
        { team_identifier: 'MZ6ZTY3EA7' },
        entitlements
      )
    end

    it 'raises user_error if aps environment does not match' do
      expect(Fastlane::UI).to receive(:user_error!).with("Mismatched aps_environment. Expected: 'production'; Found: ''")

      Fastlane::Actions::VerifyIpaEntitlementsAction.verify_entitlements(
        { aps_environment: 'production' },
        entitlements
      )
    end
  end
end
