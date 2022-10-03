# Flutter TrustWallet WalletCore

Crypthesia includes in this repository libraries and protobuf of `WalletCore 3.0.4`. This fork is more up-to-date comparing to pub.dev version and the repo linked in Wallet-Core Readme.

This repository is a Flutter plugin of `TrustWallet WalletCore` library. The full list of APIs can be seen here [https://github.com/trustwallet/wallet-core/tree/master/include/TrustWalletCore](https://github.com/trustwallet/wallet-core/tree/master/include/TrustWalletCore)

# Add This Pluggin to Your Flutter Project

## pubspec.yaml

## Android

Add

```
class MainActivity: FlutterActivity() {
    init {
        System.loadLibrary("TrustWalletCore")
    }
}
```

in your android project MainActivity.kt file

minSdk require >=23

## iOS

min ios platform support >=13.0

## Flutter App Code

before use wallet_core, call below function once.

```
 FlutterTrustWalletCore.init();
```

Then you are ready to run.

# Steps to Use Newly Built WalletCore for This Pluggin

These steps are performed in this Pluggin project (not the Flutter App project). We may want to do these steps for two reasons: to adopt newly released WalletCore library, or to be sure of security. We follow the excellent instructions of the original authors ([weishirongzhen](https://github.com/weishirongzhen/flutter_trust_wallet_core_lib_include)) to include latest WalletCore release. We will write down here the steps with our own notes to resolve a few small hurdles.

Ideally we shouldn't need to re-build WalletCore library ouselves, but should directly download the latest `WalletCore release` for [IOS](https://github.com/trustwallet/wallet-core/releases) and for [Android](https://github.com/trustwallet/wallet-core/packages/700258). However, the Android release is built with hidden CMAKE_CXX_VISIBILITY_PRESET, we cannot use if for `dart.ffi`. In this repository, we actually use the released IOS library, and only include our own-built Androild .aar file.

We will first describe what WalletCore library files we need and where to put them then follow up with steps to build WalletCore on MacOS.

## iOS

- We need `SwiftProtobuf.xcframework` and `WalletCore.xcframework` under folder `ios//Frameworks`. These libraries can be downloaded directly from [WalletCore release](https://github.com/trustwallet/wallet-core/releases).

## Android

- We need `trustwalletcore.aar` under folder `android/libs`. This .aar file is the reason we need to re-build WalletCore ourselves with a new flag as noted above. After wallet-core build, the file can be copied from `build` folder.

## Dart Protobuf

- The protobuf files are in `wallet-core` repository. So you will need to clone the [repo](https://github.com/trustwallet/wallet-core), check folder `src//proto`.

- Next we will need dart proto-pluggin, run this command `dart pub global activate protoc_plugin` to add it to `protoc` (protoc needs to be installed first).

- Create a folder to hold our dart proto files to be generated next, `mkdir dart_proto`

- From root folder of `wallet-core` folder, run this command `protoc -I=./src/proto --dart_out=./dart_proto/ ./src/proto/*.proto`. This command will look for all .proto files under src/proto and generate the dart versions and put them under dart_proto folder.

-

## Build WalletCore

Because official lib build flag in CmakeLists.txt set(CMAKE_CXX_VISIBILITY_PRESET hidden), that will cause android exception when dart ffi lookup function.

Please refer to [My other repo](https://github.com/weishirongzhen/flutter_trust_wallet_core_lib_include) to run full demo,
also, replace you own build to ensure safety.
build step: follow [Official build step](https://developer.trustwallet.com/wallet-core/developing-the-library/building) to prepare your build env , then change

```
 set(CMAKE_CXX_VISIBILITY_PRESET hidden)
```

to

```
 set(CMAKE_CXX_VISIBILITY_PRESET default)
```

build project, replace your own output in [My other repo](https://github.com/weishirongzhen/flutter_trust_wallet_core_lib_include).
