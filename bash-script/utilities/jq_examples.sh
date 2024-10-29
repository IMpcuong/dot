#!/bin/bash

# Basic match for 'test' anywhere in key name
jq 'with_entries(select(.key | contains("test")))' input.json

# Match keys that exactly equal 'test'
jq 'with_entries(select(.key == "test"))' input.json

# Match keys starting with 'test'
jq 'with_entries(select(.key | startswith("test")))' input.json

# Match keys ending with 'test'
jq 'with_entries(select(.key | endswith("test")))' input.json

# Case insensitive match for 'test' using regex
jq 'with_entries(select(.key | test("test"; "i")))' input.json

# Example input and output:
echo '{
  "test": 1,
  "testing": 2,
  "pretest": 3,
  "myTest": 4,
  "other": 5
}' | jq 'with_entries(select(.key | contains("test")))'

# Output:
# {
#   "test": 1,
#   "testing": 2,
#   "pretest": 3
# }
