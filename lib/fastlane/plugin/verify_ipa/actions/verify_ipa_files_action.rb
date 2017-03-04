module Fastlane
  module Actions
    class VerifyIpaFilesAction < Action
      def self.run(params)
        Dir.mktmpdir do |dir|
          app_path = self.app_path(params, dir)
          self.verify_files(params, app_path)
        end
      end

      def self.app_path(params, dir)
        ipa_path = params[:ipa_path] || Actions.lane_context[SharedValues::IPA_OUTPUT_PATH] || ''
        UI.user_error!("Unable to find ipa file '#{ipa_path}'.") unless File.exist?(ipa_path)

        ipa_path = File.expand_path(ipa_path)
        `unzip '#{ipa_path}' -d #{dir}`
        UI.user_error!("Unable to unzip ipa '#{ipa_path}'") unless $? == 0
        File.expand_path("#{dir}/Payload/*.app")
      end

      def self.verify_files(params, app_path)
        files_on_blacklist = []
        files_on_whitelist = []

        Dir.chdir(app_path) do
          params[:blacklist].each { |pattern| files_on_blacklist << Dir.glob(pattern) }
          params[:whitelist].each { |pattern| files_on_whitelist << Dir.glob(pattern) } if params[:whitelist]

          invalid_files = files_on_blacklist.flatten - files_on_whitelist.flatten
          UI.user_error!("Found files on the blacklist: #{invalid_files}") unless invalid_files.empty?
        end
      end

      def self.description
        'Verify files in ipa file'
      end

      def self.details
        'Make sure no sensible files (e.g. build script or mock data with sensible info) are accidentally included in ipa file'
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
          FastlaneCore::ConfigItem.new(key: :blacklist,
                                  env_name: 'VERIFY_IPA_BLACKLIST',
                               description: 'A list of glob patterns that define what files should NOT make their way into the ipa',
                                  optional: false,
                                      type: Array),
          FastlaneCore::ConfigItem.new(key: :whitelist,
                                  env_name: 'VERIFY_IPA_WHITELIST',
                               description: 'A list of glob patterns that are allowed to be included in the ipa',
                                  optional: true,
                                      type: Array)
        ]
      end

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
