require "fastlane/action"
require_relative "../helper/android_version_manager_helper"

module Fastlane
  module Actions
    # To Share a Value
    module SharedValues
      ANDROID_VERSION_CODE ||= :ANDROID_VERSION_CODE
    end

    class AndroidGetVersionCodeAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        UI.message("Parameter app_project_dir: #{params[:app_project_dir]}")
        UI.message("Parameter key: #{params[:key]}")

        # We can expect version_code to be an existing and valid version code
        version_code = Helper::AndroidVersionManagerHelper.get_version_code_from_gradle_file("#{params[:app_project_dir]}/build.gradle", params[:key])

        Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_CODE] = version_code

        return version_code
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Returns the version code of the android project"
      end

      def self.details
        "Based on the provided params, returns the value of the version code of the build.gradle file as a number"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_project_dir,
                                       env_name: "FL_ANDROID_GET_VERSION_CODE_APP_PROJECT_DIR",
                                       description: "The path to the application source folder in the Android project (default: android/app)",
                                       optional: true,
                                       type: String,
                                       default_value: "android/app",
                                       verify_block: proc do |value|
                                         # Not using File.exist?("#{value}/build.gradle") because it does not handle globs
                                         UI.user_error!("Couldn't find build.gradle file at path '#{value}'") unless Dir["#{value}/build.gradle"].any?
                                       end),
          FastlaneCore::ConfigItem.new(key: :key,
                                       env_name: "FL_ANDROID_GET_VERSION_CODE_KEY",
                                       description: "The property key",
                                       optional: true,
                                       type: String,
                                       default_value: "versionCode"),
        ]
      end

      def self.output
        [
          ["ANDROID_VERSION_CODE", "The version code specified on the build.gradle file of the project"],
        ]
      end

      def self.category
        # https://github.com/fastlane/fastlane/blob/051e5012984d97257571a76627c1261946afb8f8/fastlane/lib/fastlane/action.rb#L6-L21
        :project
      end

      # def self.example_code
      #   [
      #     'version = get_version_number(xcodeproj: "Project.xcodeproj")',
      #     'version = get_version_number(
      #       xcodeproj: "Project.xcodeproj",
      #       target: "App"
      #     )'
      #   ]
      # end

      def self.return_value
        "The Android app version code"
      end

      def self.return_type
        # https://github.com/fastlane/fastlane/blob/051e5012984d97257571a76627c1261946afb8f8/fastlane/lib/fastlane/action.rb#L23-L30
        :int
      end

      def self.authors
        ["Jonathan Cardoso", "@_jonathancardos", "JCMais"]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
