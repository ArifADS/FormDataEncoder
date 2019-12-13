# FormDataEncoder

Lightweight **Encodable** to Multipart form data

```swift
let encoder = FormDataEncoder(boundary: boundary)
let data = try! encoder.encode(form)
// send data to URLRequest body
```

## Installation

* Cocoapod
```
pod 'FormDataEncoder', :git => 'https://github.com/ArifADS/FormDataEncoder'
```

* Swift Package Manager
```
.package(url: "https://github.com/ArifADS/FormDataEncoder", from: "1.0.0")
```
