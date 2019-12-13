# FormDataEncoder

Lightweight **Encodable** to Multipart form data

```
let encoder = FormDataEncoder(boundary: boundary)
let data = try! encoder.encode(form)
// send data to URLRequest body
```
