from __future__ import print_function
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload
from httplib2 import Http
from oauth2client import file, client, tools

SCOPES = 'https://www.googleapis.com/auth/drive'


# Authenticate
def main():
    store = file.Storage('token.json')
    creds = store.get()
    if not creds or creds.invalid:
        flow = client.flow_from_clientsecrets('credentials.json', SCOPES)
        creds = tools.run_flow(flow, store)
    drive_service = build('drive', 'v3', http=creds.authorize(Http()))

    page_token = None
    while True:
        response = drive_service.files().list(q="mimeType='application/vnd.google-apps.folder'"
                                                " and name contains 'Keepass'",
                                              spaces='drive',
                                              fields="nextPageToken, files(id, name)",
                                              pageToken=page_token).execute()
        for eachfile in response.get('files', []):
            # Process change
            print('File: %s %s' % (eachfile .get('name'), eachfile.get('id')))
        page_token = response.get('nextPageToken', None)
        if page_token is None:
            break

if __name__ == '__main__':
    main()