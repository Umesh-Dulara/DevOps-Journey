#Docker file
The dockerfile is written in two stages.builder stage use python:3.11-alpine as the base layer.
Stage 1 is used for install python dependencies.
Second stage also use python:3.11-alpine as base layer which less than 100MBs.
Installed libraries and Source code is copied to the second stage.

#Makefile

Makefile has 4 targets with build, run, push and clean.
note - Makefile is targets are only rsponsible for the flask-app image except for the run which spin up the both flask-app and the database.

#version_update.sh

This is a simple bash script that update the version number in .env before building the image.
You can choose the digits to increase according to your rebuild purpose.
1. Major update
2. Minor update
3. Patch update
The script suppor all 3 choices at once.Make shure when typing seperate them with spaces.


