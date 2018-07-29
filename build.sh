#!/bin/bash


apt-get update 
apt-get install -y python-pip
pip install -t lib -r requirements.txt

sed -i "s/__PHOTO_BUCKET/$PHOTO_BUCKET/" main.py
sed -i "s/__THUMBNAILS_BUCKET/$THUMBNAILS_BUCKET/" main.py
