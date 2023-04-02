#!/usr/bin/env python3

# Esse script é utilizado para inserir a variável #+export_file_name nos arquivos .org que ela não existe
# usage: python3 org_insert_output_path.py /diretorio/onde/os/.org/estao

# ----------------------------------------------------------------------------------------------------------------------

from sys import argv
from os.path import basename
from re import match, sub
from glob import glob as scan

# parte da string que define qual é o diretório onde os arquivos .tex e .pdf são salvos
SEARCH_STR = '#+export_file_name'

# o cabeçalho dos meus arquivos .org finalizam na linha que contém essa string
HEADER_END = '------'

def removeDateFromName(fileName):
    # Alguns dos meus arquivos começam com uma sequencia de números que indicam a data e hora de sua criação, seguido
    # de um hifen e uma string que é o assunto da nota. Essa função remove a data e o hifen e retorna apenas a string
    # sem a extensão .org
    if match(r'\d+-', fileName):
        return sub(r'^\d+-', '', fileName).split(".")[0]

    else:
        return fileName.split(".")[0]

def searchString(file):
    # verifica se o arquivo é do tipo org-mode
    if file.endswith('.org'):
        with open(file, 'r+') as f:
            # ler todo o arquivo e o quebra em linhas
            content = f.read()
            lines = content.splitlines()

            # procura a sequência SEARCH_STR
            if not any(SEARCH_STR in line for line in lines):
                # essa verificação é necessária, pois, caso a sequência SEARCH_STR não exista no arquivo, eu a insiro
                # acima da linha que está HEADER_END
                if HEADER_END in lines:
                    fileName = basename(file)
                    newLine = SEARCH_STR + ": ../Outputs/" + removeDateFromName(fileName)
                    # inseri a minha newLine na linha acima da linha onde está HEADER_END (index = numero da linha)
                    lines.insert(lines.index(HEADER_END), newLine)

                    # volta ao topo do arquivo e começa a gravação
                    f.seek(0)
                    f.write('\n'.join(lines))
                    f.write(content[len('\n'.join(lines)):])
                    print(">> INFO: Arquivo alterado ", file)

                else:
                    print(">> WARNING: HEADER_END não existe em ", file)

            else:
                print(">> INFO: SEARCH_STR já existe em ", file)



def main():
    if len(argv) > 1:
        path = argv[1]
        if path[-1] != '/':
            path += '/'

        allFiles = [f for f in scan(path + "**/*.*", recursive=True)]

        for file in allFiles:
            searchString(file)

if __name__ == '__main__':
    main()
