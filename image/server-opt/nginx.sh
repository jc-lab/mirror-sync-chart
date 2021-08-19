#!/bin/bash

mkdir -p /run/nginx /data/html

exec nginx -g 'daemon off;'

