#!/bin/bash

# Limpa alguns diretórios
# CUIDADO!

MEGABYTE=1024
GIGABYTE=$((MEGABYTE * MEGABYTE))

directories=(
  "$HOME/.cache"
)

other_directories=(
  "/tmp"
  "/var/cache"
  "/var/tmp"
  #"/var/log"
  #"/var/mail"
)

DeleteFiles() {
  total_size=0

  for dir in "$@"; do
    if [ -d "$dir" ]; then
        echo "Excluindo arquivos em: $dir"

        dir_size=$(du -Lsh "$dir" | awk '{print $1}')
        total_size=$((total_size + $(du -Ls "$dir" | awk '{print $1}')))

        rm -rf "${dir}"/*
        echo "Espaço liberado: $dir_size"
    else
        echo "Diretório não encontrado: $dir"
    fi
  done

  echo "Total de espaço liberado: $(ConvertSize $total_size)"
}

ConvertSize() {
  size=$1
  if [ $size -gt $GIGABYTE ]; then
      echo "$((size / $GIGABYTE)) GB"

  else
      echo "$((size / $MEGABYTE)) MB"
  fi
}

echo "Diretórios que serão excluídos:"
for dir in "${directories[@]}"; do
    echo "- $dir ($(du -Lsh "$dir" | awk '{print $1}'))"

done

for dir in "${other_directories[@]}"; do
    echo "- $dir ($(du -Lsh "$dir" | awk '{print $1}'))"

done

read -rp "Tem certeza de que deseja excluir os diretórios acima e todos os seus arquivos? (y/n): " confirm

if [[ $confirm =~ ^[Yy]$ ]]; then
    DeleteFiles "${directories[@]}"
    DeleteFiles "${other_directories[@]}"

else
    echo "Operação cancelada."
fi
