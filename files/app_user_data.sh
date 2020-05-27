#!/bin/bash
sudo aws s3 sync s3://footgo/war /home/ec2-user
chmod 755 /home/ec2-user/ROOT.war
sudo /home/ec2-user/ROOT.war > /dev/null 2>&1&
