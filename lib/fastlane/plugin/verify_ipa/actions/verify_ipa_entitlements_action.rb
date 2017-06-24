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
          self.verify_param(:application_identifier, params[:application_identifier], entitlements['application-identifier'])
        end
        if params[:team_identifier]
          self.verify_param(:team_identifier, params[:team_identifier], entitlements['com.apple.developer.team-identifier'])
        end
        if params[:aps_environment]
          self.verify_param(:aps_environment, params[:aps_environment], entitlements['aps-environment'])
        end
        if params[:application_groups]
          self.verify_param(:application_groups, params[:application_groups], entitlements['com.apple.security.application-groups'])
        end
        if params[:other_params]
          params[:other_params].keys.each do |key|
            self.verify_param(key, params[:other_params][key], entitlements[key.to_s.tr('_', '-')])
          end
        end

        UI.success("Entitlements are verified.")
      end

      def self.verify_param(param, expected, actual)
        UI.user_error!("Mismatched #{param}. Expected: '#{expected}'; Found: '#{actual}'") unless expected == actual
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
                                  optional: true),
          FastlaneCore::ConfigItem.new(key: :team_identifier,
                                  env_name: 'VERIFY_IPA_TEAM_IDENTIFIER',
                               description: 'Key com.apple.developer.team-identifier in Entitlements',
                                  optional: true),
          FastlaneCore::ConfigItem.new(key: :aps_environment,
                                  env_name: 'VERIFY_IPA_APS_ENVIRONMENT',
                               description: 'Key aps-environment in Entitlements',
                                  optional: true),
          FastlaneCore::ConfigItem.new(key: :application_groups,
                                  env_name: 'VERIFY_IPA_APPLICATION_GROUPS',
                               description: 'Key com.apple.security.application-groups in Entitlements',
                                  optional: true,
                                      type: Array),
          FastlaneCore::ConfigItem.new(key: :other_params,
                                  env_name: 'VERIFY_IPA_OTHER_PARAMS',
                               description: 'A hash of entitlement key and expected values',
                                  optional: true,
                                      type: Hash)
        ]
      end

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
