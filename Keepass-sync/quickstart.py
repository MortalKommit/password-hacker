from __future__ import print_function
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload
from Lib import io
from httplib2 import Http
from oauth2client import file, client, tools
import shutil

# If modifying these scopes, delete the file token.json.
SCOPES = 'https://www.googleapis.com/auth/drive'

# Keepass db id = 1d_yH8xNdTUL-93ibtDMoqnfgRRku5Qtq


def main():
    """Shows basic usage of the Drive v3 API.
    Prints the names and ids of the first 10 files the user has access to.
    """
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    store = file.Storage('token.json')
    creds = store.get()
    if not creds or creds.invalid:
        flow = client.flow_from_clientsecrets('credentials.json', SCOPES)
        creds = tools.run_flow(flow, store)
    drive_service = build('drive', 'v3', http=creds.authorize(Http()))
    file_id = '1d_yH8xNdTUL-93ibtDMoqnfgRRku5Qtq'
    # Call the Drive v3 API
    request = drive_service.files().get_media(fileId=file_id)
    fh = io.BytesIO()
    media_downloader = MediaIoBaseDownload(fh, request)
    done = False

    while done is False:
        status, done = media_downloader.next_chunk()
        print("Download %d%%." % int(status.progress() * 100))
    with open('test.kdbx', 'wb') as fd:
        fh.seek(0)
        shutil.copyfileobj(fh, fd)
    '''
    results = drive_service.files().list(
        pageSize=10, fields="nextPageToken, files(id, name)").execute()
    items = results.get('files', [])

    if not items:
        print('No files found.')
    else:
        print('Files:')
        for item in items:
            print(u'{0} {1}'.format(item['name'], item['id']))
'''


if __name__ == '__main__':
    main()
