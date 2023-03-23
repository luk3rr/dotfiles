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
#
# Depends on: rclone, watchdog
# 
# --------------------------------------------------------------------------------------------------

import signal
import subprocess
from sys import exit
from os import getenv
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

LOCAL_FOLDER = getenv('LOCAL_DOCS_DIR')
REMOTE_FOLDER = getenv('REMOTE_DOCS_DIR')

# ROOT_FOLDER é o diretório raiz do servidor remoto
ROOT_FOLDER = REMOTE_FOLDER.split(":")[-1].strip('/')

# Função responsável por sincronizar a pasta local com a remota sempre que o script é inicializado
# Para diretórios grandes esse trem demora demais
def pullRemote():
    print(">> SYNC TO REMOTE")
    cmd = ["rclone", "bisync", str(LOCAL_FOLDER), str(REMOTE_FOLDER), "-vvv", "--resync", "--remove-empty-dirs"]
    log = subprocess.run(cmd, stdout=subprocess.PIPE)
    print(log.stdout.decode())

# Classe responsável por lidar com os eventos de alterações na pasta local
class myHandler(FileSystemEventHandler):
    def on_created(self, event):
        if event.is_directory:
            return None

        # A partir do caminho do arquivo alterado, acha o caminho desse arquivo no diretório remoto
        relativeRemotePath = REMOTE_FOLDER + event.src_path.split(ROOT_FOLDER)[-1].strip('/')

        # Copia o arquivo alterado para o diretório remoto e imprimi a saída do rclone
        cmd = ["rclone", "copyto", event.src_path, relativeRemotePath, "-vvv"]
        log = subprocess.run(cmd, stdout=subprocess.PIPE)
        print(log.stdout.decode())

    def on_modified(self, event):
        # Criar ou modificar um arquivo merece o mesmo comportamento, então simplesmente chame on_created
        self.on_created(event)

    def on_deleted(self, event):
        # A partir do caminho do arquivo deletado, acha o caminho desse arquivo no diretório remoto
        relativeRemotePath = REMOTE_FOLDER + event.src_path.split(ROOT_FOLDER)[-1].strip('/')

        # Deleta o arquivo no diretório remoto e imprimi a saída do rclone
        cmd = ["rclone", "delete", relativeRemotePath, "-vvv", "--rmdirs"]
        log = subprocess.run(cmd, stdout=subprocess.PIPE)
        print(log.stdout.decode())

    def on_moved(self, event):
        # A partir do caminho do arquivo, acha o caminho desse arquivo no diretório remoto e para onde ele será movido
        relativeSrcPath = REMOTE_FOLDER + event.src_path.split(ROOT_FOLDER)[-1].strip('/')
        relativeDestPath = REMOTE_FOLDER + event.dest_path.split(ROOT_FOLDER)[-1].strip('/')

        # Move o arquivo e imprimi a saída do rclone
        cmd = ["rclone", "moveto", relativeSrcPath, relativeDestPath, "-vvv"]
        log = subprocess.run(cmd, stdout=subprocess.PIPE)
        print(log.stdout.decode())

def main():
    if (LOCAL_FOLDER == None or REMOTE_FOLDER == None):
        print(">> Environment variables do not exist")
        exit()

    pullRemote()
    
    event_handler = myHandler()
    observer = Observer()

    observer.schedule(event_handler, path=LOCAL_FOLDER, recursive=True)
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
