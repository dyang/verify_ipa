module Fastlane
  module Helper
    class VerifyIpaHelper
      def self.app_path(params, dir)
        ipa_path = params[:ipa_path] || Actions.lane_context[SharedValues::IPA_OUTPUT_PATH] || ''
        UI.user_error!("Unable to find ipa file '#{ipa_path}'.") unless File.exist?(ipa_path)

        ipa_path = File.expand_path(ipa_path)
        `unzip '#{ipa_path}' -d #{dir}`
        UI.user_error!("Unable to unzip ipa '#{ipa_path}'") unless $? == 0
        File.expand_path("#{dir}/Payload/*.app")
      end
    end
  end
end
