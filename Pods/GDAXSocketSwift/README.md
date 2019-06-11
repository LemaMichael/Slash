# GDAXSocketSwift

[![Version](https://img.shields.io/cocoapods/v/GDAXSocketSwift.svg?style=flat)](http://cocoapods.org/pods/GDAXSocketSwift)
[![License](https://img.shields.io/cocoapods/l/GDAXSocketSwift.svg?style=flat)](http://cocoapods.org/pods/GDAXSocketSwift)
[![Platform](https://img.shields.io/cocoapods/p/GDAXSocketSwift.svg?style=flat)](http://cocoapods.org/pods/GDAXSocketSwift)

## Features

- WebSocket library agnostic (use any library you like! the example uses [Starscream](https://github.com/daltoniam/Starscream))
- Minimal Swift codebase with all JSON parsing handled internally
- Objects for all outgoing and incoming channel JSON
- Optional automatic request signing when subscribing to channels

Please read over the [official GDAX documentation](https://docs.gdax.com/) *before* using this library.

This library was inspired by [GDAXSwift](https://github.com/anthonypuppo/GDAXSwift).

## Requirements

- iOS 8.1+ / macOS 10.13+ / tvOS 9.0+ / watchOS 4.0+
- Xcode 9.0+
- Swift 4.0+

## Installation

GDAXSocketSwift is available through [CocoaPods](http://cocoapods.org). Check out [Get Started](http://cocoapods.org/) tab on [cocoapods.org](http://cocoapods.org/) to learn more.

To install GDAXSocketSwift, simply add the following line to your Podfile:

```ruby
pod 'GDAXSocketSwift'
```

Then run:

	pod install

## Usage

##### Import

First thing is to import the framework. See the Installation instructions above how to add the framework to your project using [CocoaPods](http://cocoapods.org).

```
import GDAXSocketSwift
```

##### Initialize

Create an instance of `GDAXSocketClient` using the available initializer. Note that it is probably best to use a property, so it doesn't get deallocated right after being setup.

The `apiKey`, `secret64`, and `passphrase` parameters are optional if you want to receive authenticated messages. Read the [official GDAX documentation](https://docs.gdax.com/) for more details on authenticated WebSocket messages.

```swift
socketClient = GDAXSocketClient(apiKey: "apiKey", secret64: "secret64", passphrase: "passphrase")
```

##### Setup WebSocket

GDAXSocketSwift is made to be used with any WebSocket library. As such, a class that conforms to the protocol `GDAXWebSocketClient` must be passed in to `GDAXSocketClient`. `GDAXSocketClient` keeps a strong reference to this socket class and handles connecting, disconnecting, receiving messages, and connection status. Check out the example project to see how to do this with [Starscream](https://github.com/daltoniam/Starscream).

```swift
socketClient?.webSocket = ExampleWebSocketClient(url: URL(string: GDAXSocketClient.baseAPIURLString)!)
```

##### Setup Logger (optional)

If you want to see logs from GDAXSocketSwift you can optionally pass a class that conforms to the protocol `GDAXSocketClientLogger`. A `GDAXSocketClientDefaultLogger` is provided with an example of basic logging.

```swift
socketClient?.logger = GDAXSocketClientDefaultLogger()
```

##### Setup Delegate

Finally, set a class to receive the delegate calls.

```swift
socketClient?.delegate = self
```

Then you can create an extension and implement the delegate methods. The delegate methods are optional (by way of empty default implementations). 

```swift
extension ViewController: GDAXSocketClientDelegate {
    func gdaxSocketDidConnect(socket: GDAXSocketClient) {
        socket.subscribe(channels:[.ticker], productIds:[.BTCUSD])
    }
    
    func gdaxSocketDidDisconnect(socket: GDAXSocketClient, error: Error?) {
        
    }
    
    func gdaxSocketClientOnErrorMessage(socket: GDAXSocketClient, error: GDAXErrorMessage) {
        print(error.message)
    }
    
    func gdaxSocketClientOnTicker(socket: GDAXSocketClient, ticker: GDAXTicker) {
        let formattedPrice = priceFormatter.string(from: ticker.price as NSNumber) ?? "0.0000"
        self.tickerLabel.text = ticker.type.rawValue
        self.priceLabel.text = "Price = " + formattedPrice
        self.productIdLabel.text = ticker.productId.rawValue
        
        if let time = ticker.time {
            self.timeLabel.text = timeFormatter.string(from: time)
        } else {
            self.timeLabel.text = timeFormatter.string(from: Date())
        }
    }
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## TODOs

- [ ] Tests...

## Author

Hani Shabsigh, [LinkedIn](http://hanishabsigh.com), [GitHub](https://github.com/hanishabsigh)

## License

GDAXSocketSwift is available under the MIT license. See the LICENSE file for more info.

## Donations

Making money using this? Support open source by donating.

Bitcoin: 1EkkFgBZp4jN21b6N85ZWDmxMohytt9L2Z

![Bitcoin](https://i.imgur.com/r7SVFZt.png)


