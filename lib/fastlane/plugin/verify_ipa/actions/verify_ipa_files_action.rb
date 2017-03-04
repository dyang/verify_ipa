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
        blacklist = params[:blacklist]
        files_on_blacklist = []
        Dir.chdir(app_path) do
          blacklist.each { |pattern| files_on_blacklist << Dir.glob(pattern) }
          UI.user_error!("Found files on the blacklist: #{files_on_blacklist}") unless files_on_blacklist.flatten!.empty?
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
                                      type: Array)
        ]
      end

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
