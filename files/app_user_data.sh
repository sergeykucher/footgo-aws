#!/bin/bash
sudo aws s3 sync s3://footgo/jar /home/ec2-user
cd /home/ec2-user
sudo java -jar ./target/ROOT.jar > /dev/null 2>&1&
