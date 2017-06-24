module Fastlane
  module Helper
    class VerifyIpaHelper
      def self.app_path(ipa_path, tmpdir)
        ipa_path ||= Actions.lane_context[Fastlane::Actions::SharedValues::IPA_OUTPUT_PATH] || ''
        UI.user_error!("Unable to find ipa file '#{ipa_path}'.") unless File.exist?(ipa_path)

        ipa_path = File.expand_path(ipa_path)
        `unzip '#{ipa_path}' -d #{tmpdir}`
        UI.user_error!("Unable to unzip ipa '#{ipa_path}'") unless $? == 0
        Dir["#{tmpdir}/Payload/*.app"].first
      end
    end
  end
end
