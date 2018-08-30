# CryptoCompKit
Unofficial client library for accessing [*CryptoCompare.com's*](https://www.cryptocompare.com/) market data

## Getting Started

### The Docs
Take a look at their [API docs](https://www.cryptocompare.com/api) for an overview and more information on the publicly available currency data.

Note: *CryptoCompKit* currently makes a limited subset of api endpoints available.  More to be added.

## Usage
All market end points are accesed through the *CryptoCompKit* class:

```swift
let cryptoCompKit = CryptoCompKit()
```

Once you have a ``CryptoCompKit()`` object instance, you can call an end point:

### List of Coins

```swift
cryptoCompKit.coinList { list, result in
  switch result {
  case .success(_):
    updateUI(coins:list.coins)
  case let .failure(error):
    handle(error:error)
  }
}

```

### List of Prices

```swift
let from = ["BTC","ETH","LTC"]
let to = ["USD"]
cryptoCompKit.priceList(fSyms:from, tSyms:to) { list, result in
	switch result {
	case .success(_):
		updateUI(prices:list.prices)
	case .failure(_):
		handle(error:error)
	}
}
```

### List of Historical Minutes (Candles)
```swift
cryptoCompKit.histoMinutes(fSym:"USD", tSym:"BTC") { list, result in
	switch result {
	case .success(_):
		updateUI(minutes:list.histos)
	case .failure(_):
		handle(error:error)
	}
}
```

## Installation
The easiest way to use *CryptoCompKit* is with CocoaPods

### Installation with CocoaPods
To integrate *CryptoCompKit* into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '11.0'

target 'TargetName' do
  pod 'CryptoCompKit'
end
```

Then, run the following command:

```bash
$ pod install
```

## Pre-Release Version
This is a pre-release version of *CryptoCompKit* and although it is stable and should be working in all the above cases, things will be added, changed and potentially break.

## License
*CryptoCompKit* is released under the **MIT** license
