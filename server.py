import os
import random
import string
import hashlib
import socket

def generate_random_text(length):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

def generate_file(file_path, size):
    with open(file_path, 'w') as f:
        f.write(generate_random_text(size))

def calculate_checksum(file_path):
    hasher = hashlib.sha256()
    with open(file_path, 'rb') as f:
        buffer = f.read(65536)
        while len(buffer) > 0:
            hasher.update(buffer)
            buffer = f.read(65536)
    return hasher.hexdigest()


def main():
    port = os.environ.get('PORT', 8000)
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(('0.0.0.0', int(port)))
    server_socket.listen(1)
    
    print(f"Server running on port {port}")

    # Get the absolute path of the directory containing the script
    script_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(script_dir, 'serverdata', 'random_file.txt')

    # Create serverdata directory if it doesn't exist
    serverdata_dir = os.path.join(script_dir, 'serverdata')
    if not os.path.exists(serverdata_dir):
        os.makedirs(serverdata_dir)

    while True:
        conn, addr = server_socket.accept()
        print('Connection from:', addr)

        # Generate file in the absolute path
        generate_file(file_path, 1024)
        checksum = calculate_checksum(file_path)

        with open(file_path, 'rb') as f:
            file_data = f.read()

        # Send file size before sending file contents
        conn.sendall(str(len(file_data)).encode())
        conn.recv(1024)  # Wait for acknowledgment from the client

        # Send file contents
        conn.sendall(file_data)

        # Send checksum
        conn.sendall(checksum.encode())

        conn.close()

if __name__ == "__main__":
    main()
