---
layout: page
title: Flutter 持续交付之 Fastlane
description: 如何通过 Fastlane 自动化持续构建和发布 Flutter 应用程序。

permalink: /fastlane-cd/
---

下面介绍的 Flutter 持续交付最佳实践能确保您的应用能快速持续的实现 beta 提测而不需要介入手工流程。

本指南介绍如何集成 [Fastlane](https://docs.fastlane.tools/)，一个提供了现成的的测试和持续集成（CI）工作流（类似的还有 Travis 和 Cirrus ）。

* TOC Placeholder
{:toc}

## 本地设置

建议您先在本地把构建和部署流程走通后再迁移到云系统上。当然，您也可以选择在本地持续交付。

1. 安装 Fastlane `gem install fastlane` 或 `brew cask install fastlane`.
1. 创建 Flutter 项目，等一切准备就绪，执行以下指令确保项目编译通过。
* ![Android](/images/fastlane-cd/android.png) `flutter build apk --release`；
* ![iOS](/images/fastlane-cd/ios.png) `flutter build ios --release --no-codesign`。
1. 初始化 Fastlane 项目。
* ![Android](/images/fastlane-cd/android.png) 在 `[project]/android`
目录下运行 `fastlane init`。
* ![iOS](/images/fastlane-cd/ios.png) 在 `[project]/ios` 目录下运行  `fastlane init`。
1. 编辑 `Appfile` 文件，确认里面描述应用的字段是否合适。
* ![Android](/images/fastlane-cd/android.png) `[project]/android/Appfile` 里的 `package_name` 要和 pubspec.yaml 里的包名相匹配。
* ![iOS](/images/fastlane-cd/ios.png) `[project]/ios/Appfile` 里的  `app_identifier` 字段也要能匹配得上。并填写和个人账户信息相关的： `apple_id`， `itc_team_id`，
`team_id` 。
1. 在本地准备应用商店的登录凭证。
* ![Android](/images/fastlane-cd/android.png) 按照 [Supply的设置步骤](https://docs.fastlane.tools/getting-started/android/setup/#setting-up-supply) 操作,确保 `fastlane supply init` 成功同步了您在应用商店的数据。 _把 .json 文件像密码一样对待，不要提交到任何公共代码仓库。_
* ![iOS](/images/fastlane-cd/ios.png) 你连接到 iTunes 的用户名已经保存在  `Appfile` 里的 `apple_id` 字段。设置 `FASTLANE_PASSWORD` shell 环境变量为你的 iTunes 连接密码。 否则，当你把应用上传到 iTunes/TestFlight 时会遇到提示框提示你输入密码。
1. 设置代码签名。
* ![Android](/images/fastlane-cd/android.png) 在 Android 中, 有两种类型的签名密钥: 部署秘钥和上传秘钥。最终用户下载的apk签署的是“部署密钥”。“上传密钥”用于开发人员上传再签名的 apk 而该应用在应用商店曾经被部署秘钥签过名时的权限验证。

* 强烈建议通过云服务自动托管签名的部署密钥。更多详细信息，请参阅[应用商店官方文档](https://support.google.com/googleplay/android-developer/answer/7384423?hl=en)。
* 按照 [密钥生成步骤](https://developer.android.com/studio/publish/app-signing#sign-apk)
介绍的创建和上传密钥。
* 在 gradle 中，设置在 release 模式下用上传密钥构建 app - 通过编辑  `android.buildTypes.release` 里的
`[project]/android/app/build.gradle`.
* ![iOS](/images/fastlane-cd/ios.png) iOS：当你准备在 TestFlight 或 App Store 上测试和部署应用时用的应该是发行证书而不是开发证书。
* 在你的 [Apple 开发者账户控制台](https://developer.apple.com/account/ios/certificate/)创建和下载发行证书。
* 打开 `[project]/ios/Runner.xcworkspace/` 在 setting 面板选择发布证书。
1. 创建一个 `Fastfile` 脚本。
* ![Android](/images/fastlane-cd/android.png) Android: 按照
[Fastlane Android beta 部署指南](https://docs.fastlane.tools/getting-started/android/beta-deployment/)操作。
编辑起来可以像添加一个 `lane` 用来调用 `upload_to_play_store` 一样简单。
用 `flutter build` 生成的apk，会将将 `apk` 参数信息设置到 `../build/app/outputs/apk/release/app-release.apk` 里。
* ![iOS](/images/fastlane-cd/ios.png) iOS: 按照 [Fastlane iOS beta 部署指南](https://docs.fastlane.tools/getting-started/ios/beta-deployment/)操作。
编辑起来可以像添加一个 `lane` 用来调用 `build_ios_app` 带上 `export_method: 'app-store'` 或 `upload_to_testflight` 一样简单。iOS 编译还要额外注意的是，flutter build 构建出的 .app 而不是一个 release 版的 .ipa。

现在，你已经做好了本地部署或迁移到持续集成（CI）系统部署的准备了。  

## 执行本地部署

1. 在 release 模式下构建应用。
* ![Android](/images/fastlane-cd/android.png) `flutter build apk --release`.
* ![iOS](/images/fastlane-cd/ios.png) `flutter build ios --release --no-codesign`.
这个阶段不需要签名，Fastlane 将在打包时自动签名。
1. 运行 Fastfile 脚本。
* ![Android](/images/fastlane-cd/android.png) `cd android` 后
`fastlane [name of the lane you created]`.
* ![iOS](/images/fastlane-cd/ios.png) `cd ios` 后
`fastlane [name of the lane you created]`.

## 设置云构建和云部署

首先，根据确保上面”本地配置“内容里介绍的对本地配置的描述信息在迁移到一个类似 Travis 云系统之前能运作起来。

需要注意到的是，既然云端的实例是短暂的、不受信任的。你会像对待自己的证件一样保密包含你应用商店的账户信息的 JSON 和 iTunes 分配给你的证书。

在 CI 系统里，像 [Cirrus](https://cirrus-ci.org/guide/writing-tasks/#encrypted-variables) 支持通过加密的环境变量保存私有数据。

**特别注意在测试脚本中不要将这些变量返回给控制台**。这些变量在 pull request 被合并之前都是不可读取的，以防止有人恶意通过创建一个新的拉取请求来打印这些秘密数据。记得小心在操作接收和合并拉取请求时不要泄漏这些秘密数据。

1. 使用临时登录证书。
* ![Android](/images/fastlane-cd/android.png) Android:
* 替换 `Appfile` 中的 `json_key_file` 字段为在你的 CI 系统中变量加密后生成的 JSON 字符串内容。通过 `upload_to_play_store` 的 `json_key_data` 参数直接读取你的 `Fastfile` 的环境变量。
* 序列化你的上传密钥（比如 Base64 ）并将其保存为加密后的环境变量。你可以在 CI 系统安装时期通过以下命令反序列化它:
```bash
echo "$PLAY_STORE_UPLOAD_KEY" | base64 --decode > /home/cirrus/[directory # and filename specified in your gradle].keystore
```
* ![iOS](/images/fastlane-cd/ios.png) iOS:
* 替换 `FASTLANE_PASSWORD` 本地环境变量，使用经过 CI 系统加密后的环境变量。
* CI 系统需要你发行证书的权限。推荐使用 Fastlane 的[ Match ](https://docs.fastlane.tools/actions/match/)系统帮助你在不同机器之间同步证书。

2. 推荐使用 Gemfile 来确保 Fastlane 在本地和在云端机器上的依赖是稳定和可重复的，而不是每次都在 CI 系统 `gem install fastlane`。然而，这个步骤是并不是强制的。
* 无论在 `[project]/android` 目录下还是 `[project]/ios` 目录下创建一个 `Gemfile` 都要包含以下内容：



```
source "https://rubygems.org"

gem "fastlane"
```


* 在上面的目录下运行 `bundle update` ，并提交 `Gemfile` 和 `Gemfile.lock` 到版本控制。
* 通过 `bundle exec fastlane` 执行本地运行而不是 `fastlane`。

3. 在工程仓库的根目录创建如 `.travis.yml` 或 `.cirrus.yml` 的 CI 测试脚本。
* 这个脚本在 Linux 和 OSX 平台都可以运行。
* 记得声明 OSX 需要 Xcode 的最低版本（例如：`osx_image: xcode9.2`）。
* 查看[ Fastlane CI 文档](https://flutter.io/fastlane-cd/)了解 CI 配置细节。
* 在安装阶段需要确保：
* `gem install bundler` 后 Bundler 是有效的。
* Android：确保 Android SDK 可用的，并设定了 `ANDROID_HOME` path 环境变量。
* `[project]/android` 或 `[project]/ios` 目录下运行 `bundle install`。
* 确保 `PATH` 配置的 Flutter SDK 的地址可用。
* 在脚本解析阶段执行 CI task：
* 根据依赖平台的不同，在 Android 下运行 `flutter build apk --release`，在 iOS 下运行 `flutter build ios --release --no-codesign`。
* `cd android` 或 `cd ios`.
* `bundle exec fastlane [lane 的名字]`.

## 参考示例

[Flutter Gallery in the Flutter repo](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery) 这个示例项目就是基于 Fastlane 持续部署。参见其中的示例代码，里面 travis 脚本[位置](https://github.com/flutter/flutter/blob/master/.cirrus.yml)。
