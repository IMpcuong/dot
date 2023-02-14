#!/bin/bash

git ls-files | nl | awk -F' ' '{ print $1 }' | tail -n1
