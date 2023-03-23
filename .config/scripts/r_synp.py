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
from threading import Timer
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler, FileClosedEvent, FileOpenedEvent

LOCAL_FOLDER = getenv('LOCAL_DOCS_DIR')
REMOTE_FOLDER = getenv('REMOTE_DOCS_DIR')

# Função responsável por sincronizar a pasta local com a remota sempre que o script é inicializado
def pullRemote():
    print(">> SYNC TO REMOTE")
    cmd = ["rclone", "bisync", str(LOCAL_FOLDER), str(REMOTE_FOLDER), "-vvv", "--resync"]
    log = subprocess.run(cmd, stdout=subprocess.PIPE)
    print(log.stdout.decode())

# Função de callback que será chamada sempre que um evento for capturado
def syncFolder(events):
    print(">> EVENT DETECTED")

    for event in events:
        print(event.src_path, event.event_type)

    cmd = ["rclone", "bisync", str(LOCAL_FOLDER), str(REMOTE_FOLDER), "-vvv", "--max-delete", "1000"]
    log = subprocess.run(cmd, stdout=subprocess.PIPE)
    print(log.stdout.decode())

# Classe responsável por lidar com os eventos de alterações na pasta local
class my_handler(FileSystemEventHandler):
    # Construtor da classe
    def __init__(self, callback):
        self.events_buffer = []
        self.callback = callback
        self.timer = None
  
    # Copia a lista de eventos capturados para a variável 'events' e esvazia a lista events_buffer
    # callback é a função que por fim chama syncFolder e mete bronca
    def empty_event_buffer(self):
        events = self.events_buffer.copy()
        self.events_buffer.clear()
        self.callback(events)
    
    # Override do método on_any_event
    def on_any_event(self, event):
        # Ignora os eventos de abertura/fechamento de arquivo ou eventos do tipo diretório
        # Não quero sincronizar quando for algum deles
        if event.is_directory or isinstance(event, FileClosedEvent) or isinstance(event, FileOpenedEvent):
            return None

        self.events_buffer.append(event)

        # Se o timer estiver rodando ele reseta para aguardar mais 10 segundos e capturar mais eventos, caso ocorram
        # Faço isso para que o rclone não realize uma sincronização por arquivo, ou seja, minimize as  
        # chamadas no Onedrive (mesmo pagando eles me dão block '-')
        if self.timer is not None:
            self.timer.cancel()

        # Chama o método empty_event_buffer após 10 seg
        self.timer = Timer(10.0, self.empty_event_buffer)
        self.timer.start()

def main():
    if (LOCAL_FOLDER == None or REMOTE_FOLDER == None):
        print(">> Environment variables do not exist")
        exit()

    pullRemote()
    
    event_handler = my_handler(syncFolder)
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
