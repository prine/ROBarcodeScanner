# ROBarcodeScanner
Scans different Barcodes and returns the result as String. Inspired by the Tutorial from Appcoda: [AppCoda](http://www.appcoda.com/qr-code-reader-swift/).

## Installation

ROBarcodeScanner is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ROBarcodeScanner"
```

## How to use

The ROBarcodeScannerViewController is a predefined view for the scanning. It shows the video and a result label on the bottom of the screen. When it detects an accepted barcode it does mark the barcode in the video window with green border. With a tap on the screen the user can confirm that the correct barcode was scanned and the callback is called.

![ROBarcodeScanner Example](https://raw.githubusercontent.com/prine/ROBarcodeScanner/master/Screenshot.png)

```swift
var barcodeScanner:ROBarcodeScannerViewController?

// Define the callback which handles the returned result
barcodeScanner?.barcodeScanned = { (barcode:String) in
    // The scanned result can be fetched here
    println("Barcode scanned: \(barcode)")
}

// Push the view
if let barcodeScanner = self.barcodeScanner {
    self.navigationController?.pushViewController(barcodeScanner, animated: true)
}

```

## License

```
The MIT License (MIT)

Copyright (c) 2015 Robin Oster (http://prine.ch)

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

## Author

Robin Oster, robin.oster@rascor.com
