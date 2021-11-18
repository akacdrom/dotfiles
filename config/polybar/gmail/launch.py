#!/usr/bin/env python

import time
import argparse
import subprocess
from pathlib import Path
from googleapiclient import discovery, errors
from google.oauth2.credentials import Credentials
from httplib2 import ServerNotFoundError

import gi
gi.require_version("Notify", "0.7")
from gi.repository import Notify, GdkPixbuf


parser = argparse.ArgumentParser()
parser.add_argument('-l', '--label', default='INBOX')
parser.add_argument('-p', '--prefix', default='\uf0e0')
parser.add_argument('-c', '--color', default='#5921ff')
parser.add_argument('-ns', '--nosound', action='store_true')
args = parser.parse_args()

DIR = Path(__file__).resolve().parent
CREDENTIALS_PATH = Path(DIR, 'credentials.json')

unread_prefix = '%{F' + args.color + '}' + args.prefix + ' %{F-}'
error_prefix = '%{F' + args.color + '}\uf06a %{F-}'
count_was = 0

def print_count(count, is_odd=False):
    tilde = '~' if is_odd else ''
    output = ''
    if count > 0:
        output = '%{F#838CBA}[%{F-}'+unread_prefix + tilde + str(count) + '%{F#838CBA}]%{F-}'
    print(output, flush=True)

def update_count(count_was):
    creds = Credentials.from_authorized_user_file(CREDENTIALS_PATH)
    gmail = discovery.build('gmail', 'v1', credentials=creds)
    labels = gmail.users().labels().get(userId='me', id=args.label).execute()
    count = labels['messagesUnread']
    print_count(count)
    if not args.nosound and count_was < count and count > 0:
        subprocess.run(['canberra-gtk-play', '-i', 'message'])
        Notify.init("gmail")
        # Create the notification object
        summary = "<------You got mailed!------>"
        body = "New mail from G-mail."
        notification = Notify.Notification.new(summary)
        image = GdkPixbuf.Pixbuf.new_from_file("/usr/share/icons/Papirus-Dark/48x48/apps/gmail.svg")
		# Use the GdkPixbuf image
        notification.set_image_from_pixbuf(image)
        # Actually show on screen
        notification.set_urgency(2)
        notification.show()
        Notify.uninit
    return count

print_count(0, True)

while True:
    try:
        if Path(CREDENTIALS_PATH).is_file():
            count_was = update_count(count_was)
            time.sleep(120)
        else:
            print(error_prefix + 'credentials not found', flush=True)
            time.sleep(120)
    except errors.HttpError as error:
        if error.resp.status == 404:
            print(error_prefix + f'"{args.label}" label not found', flush=True)
        else:
            print_count(count_was, True)
        time.sleep(60)
    except (ServerNotFoundError, OSError):
        print_count(count_was, True)
        time.sleep(60)
