#!/bin/bash
docker build -t wayf:latest .
docker stop mzk_wayf
docker rm mzk_wayf
docker run -p 80:80 --name mzk_wayf wayf:latest
