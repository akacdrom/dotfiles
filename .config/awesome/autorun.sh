#!/usr/bin/env bash
if ! pgrep -f "chrome" ;
then
  google-chrome-stable
fi
