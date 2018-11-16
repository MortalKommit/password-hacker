from __future__ import print_function
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload
from httplib2 import Http
from oauth2client import file, client, tools


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

    '''
    file_id = '1d_yH8xNdTUL-93ibtDMoqnfgRRku5Qtq'
    # Call the Drive v3 API
    file_metadata = {
        'name': 'Keepass_sync',
        'mimeType': 'application/vnd.google-apps.folder'
    }
    filefolder = drive_service.files().create(body=file_metadata,
                                        fields='id').execute()
    print('Folder ID: %s' % filefolder.get('id'))
    '''

    folder_id = '1M34OnInEcU93z9DTwwyI18V1T9qFmzIk'
    file_metadata = {
        'name': 'keepass_sync.kdbx',
        'parents': [folder_id]
    }
    media = MediaFileUpload('test.kdbx',
                            mimetype='application/media',
                            resumable=True)
    filedb = drive_service.files().create(body=file_metadata,
                                        media_body=media,
                                        fields='id').execute()
    print
    'File ID: %s' % filedb.get('id')


if __name__ == '__main__':
    main()
