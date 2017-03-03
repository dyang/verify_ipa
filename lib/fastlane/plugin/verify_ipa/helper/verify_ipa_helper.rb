module Fastlane
  module Helper
    class VerifyIpaHelper
      # class methods that you define here become available in your action
      # as `Helper::VerifyIpaHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the verify_ipa plugin helper!")
      end
    end
  end
end
