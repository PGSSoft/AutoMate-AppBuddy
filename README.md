<div align="center">
    <img src="assets/logo.png" alt="AutoMate, made by PGS Software" />
    <br />
    <img src="assets/made-with-love-by-PGS.png" />
    <p>
      <a href="https://github.com/PGSSoft/AutoMate">AutoMate</a> &bull;
      <b>AppBuddy</b> &bull;
      <a href="https://github.com/PGSSoft/AutoMate-Templates">Templates</a> &bull;
      <a href="https://github.com/PGSSoft/AutoMate-ModelGenie">ModelGenie</a>
    </p>
</div>

# AutoMate AppBuddy

`AppBuddy` is a helper framework for UI automation tests, designed to work with the [`AutoMate`](https://github.com/PGSSoft/AutoMate). It can disable animations in the application and manage events, reminders and contacts.

[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://swift.org)
[![Travis](https://img.shields.io/travis/PGSSoft/AutoMate-AppBuddy.svg)](https://travis-ci.org/PGSSoft/AutoMate-AppBuddy)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/AutoMate-AppBuddy.svg)](https://cocoapods.org/pods/AutoMate-AppBuddy)
[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/AutoMate-AppBuddy.svg)](http://cocoadocs.org/docsets/AutoMate-AppBuddy)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/AutoMate-AppBuddy.svg)](http://cocoadocs.org/docsets/AutoMate-AppBuddy)
[![License](https://img.shields.io/github/license/PGSSoft/AutoMate-AppBuddy.svg)](https://github.com/PGSSoft/AutoMate-AppBuddy/blob/master/LICENSE)

## Installation

The most convenient way to install it is by using [CocoaPods](https://cocoapods.org) with Podfile:

```ruby
pod 'AutoMate-AppBuddy'
```

or using [Carthage](https://github.com/Carthage/Carthage) and add a line to `Cartfile.private`:

```
github "PGSSoft/AutoMate-AppBuddy"
```

`Cartfile.private` should be used because AutoMate framework will be used by UI Tests target only not by the tested application.

### Note

`AppBuddy` should be linked with target application, not with the test target.

## Usage

Full documentation is available at [CocoaDocs.org](http://cocoadocs.org/docsets/AutoMate-AppBuddy).

1. Duplicate existing application target.
2. Import `AutoMate_AppBuddy` framework to app delegate.

    ```swift
    import AutoMate_AppBuddy
    ```

3. Setup `LaunchEnvironmentManager` in `application(_:didFinishLaunchingWithOptions:)`.

    ```swift
    let launchEnvironmentManager = LaunchEnvironmentManager()
    launchEnvironmentManager.add(handler: defaultEventKitHander, for: .events)
    launchEnvironmentManager.add(handler: defaultEventKitHander, for: .reminders)
    launchEnvironmentManager.add(handler: defaultContactsHander, for: .contacts)
    launchEnvironmentManager.setup()
    ```

## Features (or ToDo)

- [x] Disable UIView animations
- [x] Managing events, reminders and contacts
- [ ] Two way communication
- [ ] Stubbing network requests
- [ ] Stubbing contacts, events and reminders
- [ ] Stubbing notifications
- [ ] Making screenshots
- [ ] Clearing application data
- [ ] Simulating push notifications

## Example application

[`AutoMate`](https://github.com/PGSSoft/AutoMate) repository contains example application under `AutoMateExample` directory. Structure of the application is simple, but the project contains extensive suite of UI tests to showcase capabilities of the library.

## Development

Full documentation is available at [CocoaDocs.org](http://cocoadocs.org/docsets/AutoMate-AppBuddy).

If you want to handle your custom launch environments, you have to implement `Handler` protocol, e.g.

```swift
struct CustomHandler: Handler {
    func handle(key: String, value: String) {
        if value == "production" {

        }
    }
}

launchEnvironmentManager.add(handler: CustomHandler(), for: "SERVER")
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/PGSSoft/AutoMate-AppBuddy](https://github.com/PGSSoft/AutoMate-AppBuddy).

## License

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## About
The project maintained by software development agency [PGS Software](https://www.pgs-soft.com).
See our other [open-source projects](https://github.com/PGSSoft) or [contact us](https://www.pgs-soft.com/contact-us) to develop your product.

## Follow us

[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=https://github.com/PGSSoft/AutoMate-AppBuddy)  
[![Twitter Follow](https://img.shields.io/twitter/follow/pgssoftware.svg?style=social&label=Follow)](https://twitter.com/pgssoftware)
