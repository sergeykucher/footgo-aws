#!/bin/bash
sudo aws s3 --region=eu-central-1 sync s3://footgo/target /footgo
sudo chmod 755 /footgo/ROOT.war
sudo /footgo/ROOT.war > /dev/null 2>&1&
