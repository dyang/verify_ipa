require 'plist'

module Fastlane
  module Actions
    class VerifyIpaEntitlementsAction < Action
      def self.run(params)
        Dir.mktmpdir do |dir|
          app_path = Helper::VerifyIpaHelper.app_path(params, dir)
          entitlements = self.read_entitlements(params, app_path)
          self.verify_entitlements(params, entitlements)
        end
      end

      def self.read_entitlements(params, app_path)
        profile_path = "#{app_path}/embedded.mobileprovision"
        profile_plist = sh("security cms -D -i #{profile_path}")
        UI.user_error!("Unable to extract profile") unless $? == 0

        profile = Plist.parse_xml(profile_plist)
        profile['Entitlements']
      end

      def self.verify_entitlements(params, entitlements)
        if params[:application_identifier]
          UI.user_error!("Mismatched application_identifier. Expected: '#{params[:application_identifier]}'; Found: '#{entitlements['application-identifier']}'") unless params[:application_identifier] == entitlements["application-identifier"]
        end
      end

      def self.description
        'Verify ipa entitlements'
      end

      def self.authors
        ['Derek Yang']
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :ipa_path,
                                  env_name: 'VERIFY_IPA_IPA_PATH',
                               description: 'Explicitly set the ipa path',
                                  optional: true),
          FastlaneCore::ConfigItem.new(key: :application_identifier,
                                  env_name: 'VERIFY_IPA_APPLICATION_IDENTIFIER',
                               description: 'Key application-identifier in Entitlements',
                                  optional: true)
        ]
      end

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
