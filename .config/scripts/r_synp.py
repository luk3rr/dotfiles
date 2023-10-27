#!/usr/bin/env python3

#____/\\\\\\\\\___________________________/\\\\\\\\\\\____/\\\________/\\\__/\\\\\_____/\\\__/\\\\\\\\\\\\\___        
# __/\\\///////\\\_______________________/\\\/////////\\\_\///\\\____/\\\/__\/\\\\\\___\/\\\_\/\\\/////////\\\_       
#  _\/\\\_____\/\\\______________________\//\\\______\///____\///\\\/\\\/____\/\\\/\\\__\/\\\_\/\\\_______\/\\\_      
#   _\/\\\\\\\\\\\/________________________\////\\\_____________\///\\\/______\/\\\//\\\_\/\\\_\/\\\\\\\\\\\\\/__     
#    _\/\\\//////\\\___________________________\////\\\____________\/\\\_______\/\\\\//\\\\/\\\_\/\\\/////////____    
#     _\/\\\____\//\\\_____________________________\////\\\_________\/\\\_______\/\\\_\//\\\/\\\_\/\\\_____________   
#      _\/\\\_____\//\\\_____________________/\\\______\//\\\________\/\\\_______\/\\\__\//\\\\\\_\/\\\_____________  
#       _\/\\\______\//\\\__/\\\\\\\\\\\\\\\_\///\\\\\\\\\\\/_________\/\\\_______\/\\\___\//\\\\\_\/\\\_____________ 
#        _\///________\///__\///////////////____\///////////___________\///________\///_____\/////__\///______________
# 
# AUTHOR: luk3rr
# GITHUB: @luk3rr
#
# A script that monitors changes in a folder and runs rclone to sync it
# DISCLAIMER: This amateur script can make you lose files '-'
#
# Depends on: rclone, watchdog
# 
# --------------------------------------------------------------------------------------------------

import signal
import subprocess
from sys import exit
import os.path
from os import getenv
from threading import Timer
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

LOCAL_PATH = getenv('LOCAL_DOCS_DIR')
REMOTE_PATH = getenv('REMOTE_DOCS_DIR')

# Função responsável por sincronizar a pasta local com a remota sempre que o script é inicializado
# Para diretórios grandes esse trem demora demais
def pullRemote():
    print(">> SYNC TO REMOTE")
    cmd = ["rclone", "bisync", "--update", "--fast-list", str(LOCAL_PATH), str(REMOTE_PATH), "-vvv", "--resync", "--remove-empty-dirs"]
    log = subprocess.run(cmd, stdout=subprocess.PIPE)
    print(log.stdout.decode())

# Classe responsável por lidar com os eventos de alterações na pasta local
class myHandler(FileSystemEventHandler):
    def __init__(self):
        self.timer = None
        self.buffer = {}

    def flush_buffer(self, event):
        # A partir do caminho do arquivo alterado, acha o caminho desse arquivo no diretório remoto
        relativeRemotePath = REMOTE_PATH + event.src_path.split(LOCAL_PATH)[-1]

        # Copia o arquivo alterado para o diretório remoto e imprimi a saída do rclone
        cmd = ["rclone", "copyto", event.src_path, relativeRemotePath, "-vvv"]
        log = subprocess.run(cmd, stdout=subprocess.PIPE)
        print(log.stdout.decode())
        print(">> WAITING...")
        
        # Esvazia o buffer para os próximos eventos
        self.buffer.pop(event.src_path, None)

    def on_created(self, event):
        # Ignora arquivos temporários
        if os.path.splitext(event.src_path)[1] == '.tmp':
            print("> TEMPORARY FILE")
            return None

        # Ignora arquivos que ainda estejam em download
        if os.path.splitext(event.src_path)[1] == '.crdownload':
            print("> DOWNLOADING FILE")
            return None

        if event.is_directory:
            return None
        
        # Quando um arquivo é criado ou modificado, o SO reporta vários eventos de on_created e on_modified, 
        # pois o arquivo normalmente é criado/modificado em partes.
        # Para evitar várias chamadas para a mesma alteração, armazenamos todos os eventos reportados pelo mesmo arquivo
        # no intervalo de 1 seg em um buffer e chamamos a função flush_buffer para enviar essas alterações para a pasta remota
        file_event = f"{event.event_type} - {event.src_path}"
        filepath = event.src_path

        if filepath in self.buffer:
            self.buffer[filepath].append(file_event)
        else:
            self.buffer[filepath] = [file_event]

        if self.timer is not None:
            self.timer.cancel()

        self.timer = Timer(1, self.flush_buffer, args=[event])
        self.timer.start()
        
    def on_modified(self, event):
        # Criar ou modificar um arquivo merece o mesmo comportamento, então simplesmente chame on_created
        self.on_created(event)

    def on_deleted(self, event):
        if event.is_directory:
            return None

        # A partir do caminho do arquivo alterado, acha o caminho desse arquivo no diretório remoto
        relativeRemotePath = REMOTE_PATH + event.src_path.split(LOCAL_PATH)[-1]

        # Copia o arquivo alterado para o diretório remoto e imprimi a saída do rclone
        cmd = ["rclone", "delete", relativeRemotePath, "-vvv"]

        # Deleta o arquivo no diretório remoto e imprimi a saída do rclone
        log = subprocess.run(cmd, stdout=subprocess.PIPE)
        print(log.stdout.decode())
        print(">> WAITING...")

    def on_moved(self, event):
        if event.is_directory:
            return None

        # A partir do caminho do arquivo, acha o caminho desse arquivo no diretório remoto e para onde ele será movido
        relativeSrcPath = REMOTE_PATH + event.src_path.split(LOCAL_PATH)[-1]
        relativeDestPath = REMOTE_PATH + event.dest_path.split(LOCAL_PATH)[-1]
        # Move o arquivo e imprimi a saída do rclone
        cmd = ["rclone", "moveto", relativeSrcPath, relativeDestPath, "-vvv"]
        print(">> WAITING...")
        log = subprocess.run(cmd, stdout=subprocess.PIPE)
        print(log.stdout.decode())

def main():
    global REMOTE_PATH
    global LOCAL_PATH
    if (LOCAL_PATH == None or REMOTE_PATH == None):
        print(">> Environment variables do not exist")
        exit()

    if LOCAL_PATH[-1] != "/":
        LOCAL_PATH += "/"

    if REMOTE_PATH[-1] != "/":
        REMOTE_PATH += "/"

    #pullRemote()
    
    event_handler = myHandler()
    observer = Observer()

    observer.schedule(event_handler, path=LOCAL_PATH, recursive=True)
    print("> Monitoring started")
    observer.start()

    def stopSync(signal, frame):
        print(">> RECEIVED SIGTERM")
        observer.stop()
        observer.join()
        print("> Monitoring finished")
        exit(0)

    signal.signal(signal.SIGTERM, stopSync)
    signal.signal(signal.SIGINT, stopSync)

    observer.join()

if __name__ == "__main__":
    main()  
