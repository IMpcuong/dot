#!/usr/bin/python

import base64
import hmac
from hashlib import sha1

access_k = "ACCESSKEYID".encode("UTF-8")
secret_k = "SECRETKEYID".encode("UTF-8")

content = "<content>something</content>".encode("UTF-8")

signature = base64.encodestring(hmac.new(secret_k, content, sha1).digest()).strip()

print("AWS %s:%s" %(access_k.decode(), signature.decode()))
