from __future__ import print_function
from googleapiclient.discovery import build

from googleapiclient.http import MediaFileUpload
from httplib2 import Http
from oauth2client import file, client, tools

SCOPES = 'https://www.googleapis.com/auth/drive.file'


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
                                                " and name = 'Keepass_sync.kdbx'",
                                              spaces='drive',
                                              fields="nextPageToken, files(id, name)",
                                              pageToken=page_token).execute()
        for each_file in response.get('files', []):
            # Process change
            print('File: %s %s' % (each_file .get('name'), each_file.get('id')))
        page_token = response.get('nextPageToken', None)
        if page_token is None:
            media_upload_check = True
            break

    # Create Keepass_sync folder if it doesn't already exist
    if media_upload_check:
        file_metadata = {
            'name': 'Keepass_sync',
            'mimeType': 'application/vnd.google-apps.folder'
        }
        file_folder = drive_service.files().create(body=file_metadata,
                                                   fields='id').execute()
        print('Folder ID: %s' % file_folder.get('id'))
        keepass_folder_id = file_folder.get('id')

        file_metadata = {
            'name': 'keepass_sync.kdbx',
            'parents': [keepass_folder_id]
        }
        media = MediaFileUpload('test.kdbx',
                                mimetype='application/media',
                                resumable=True)
        filedb = drive_service.files().create(body=file_metadata,
                                              media_body=media,
                                              fields='id').execute()
        print('File ID: %s' % filedb.get('id'))


if __name__ == '__main__':
    main()
