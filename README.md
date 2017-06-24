# verify_ipa plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-verify_ipa)
[![Gem](https://badge.fury.io/rb/fastlane-plugin-verify_ipa.svg)](https://badge.fury.io/rb/fastlane-plugin-verify_ipa)
[![Build Status](https://travis-ci.org/dyang/verify_ipa.svg?branch=master)](https://travis-ci.org/dyang/verify_ipa)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-verify_ipa`, add it to your project by running:

```bash
fastlane add_plugin verify_ipa
```

## About verify_ipa

verify_ipa is a collection of Fastlane actions that are used to test various aspects of the iOS ipa file. These actions are especially useful when used in conjunction within a CI/CD pipeline to automatically test that the exported binaries are packaged correctly. 

### verify_ipa_files

Sometimes it's easy to accidentally checked the wrong Xcode target membership and have wrong files included in the ipa. This could potentially be risky if the files happen to contain sensitive information. With the verify_ipa_files action it's possible to proactively define a blacklist to fail the build if certain sensitive files make their way into the ipa. e.g.

```bash
verify_ipa_files(
    blacklist: ['*.sh', '*.json']
)

verify_ipa_files(
    blacklist: ['*.{sh,rb,env}']
)

```

It's also possible to define a whitelist to make an exception:

```bash
verify_ipa_files(
    blacklist: ['*.sh', '*.json'],
    whitelist: ['offline_data.json']
)
```

In the above example, offline_data.json is allowed to be packaged in the ipa file even though the blacklist `*.json` disallows all json files.

### verify_ipa_entitlements

Similar to the official [verify_build action](https://github.com/fastlane/fastlane/blob/master/fastlane/lib/fastlane/actions/verify_build.rb), this action verifies various settings of the ipa entitlements.

```bash
verify_ipa_entitlements(
    application_identifier: 'MZ6ZTY3EA7.com.apple.myapp',
    team_identifier: 'MZ6ZTY3EA7',
    aps_environment: 'production'
)
```

There's also an optional `:other_params` parameter that takes in a hash. This can be used to test all entitlement parameters in a generic way, e.g:

```bash
verify_ipa_entitlements(
    application_identifier: 'MZ6ZTY3EA7.com.apple.myapp',
    team_identifier: 'MZ6ZTY3EA7',
    aps_environment: 'production',
    other_params: {
        keychain_access_groups: ['MZ6ZTY3EA7.*'],
        get_task_allow: false,
        beta_reports_active: true
        }
)
```

To test application extensions, use the `:extensions` parameter, e.g:

```bash
verify_ipa_entitlements(
    application_identifier: 'MZ6ZTY3EA7.com.apple.myapp',
    team_identifier: 'MZ6ZTY3EA7',
    aps_environment: 'production',
    application_groups: [
        'group.com.apple.mygroup'
    ]
    extensions: {
        'My Great Extension': {
            application_identifier: 'MZ6ZTY3EA7.com.apple.myapp.ext',
            team_identifier: 'MZ6ZTY3EA7',
            application_groups: [
                'group.com.apple.mygroup'
            ]
        }
    }
)
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About `fastlane`

`fastlane` is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
