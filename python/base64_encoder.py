#!/usr/bin/python

import base64

data = "user:password"

encodedBytes = base64.b64encode(data.encode("utf-8"))
encodedStr = str(encodedBytes)

print(encodedStr)
