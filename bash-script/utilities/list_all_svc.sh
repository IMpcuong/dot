#!/bin/bash

sudo systemctl list-units --type service
sudo systemctl list-units --type service -all
sudo systemctl list-unit-files
sudo systemctl status -l nginx.service
sudo systemctl is-active nginx.service
