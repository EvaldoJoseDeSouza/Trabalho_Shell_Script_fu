#!/bin/bash

echo "Qual diretório você deseja verificar?"
read DIR

if [ ! -d "$DIR" ]; then
    echo "[ERRO] O diretório informado não existe."
    exit 1
fi

echo "[OK] Diretório encontrado: $DIR"

if [ ! -r "$DIR" ]; then
    echo "[AVISO] Sem permissão de leitura."
fi

if [ ! -w "$DIR" ]; then
    echo "[AVISO] Sem permissão de escrita."
fi

if [ ! -x "$DIR" ]; then
    echo "[AVISO] Sem permissão de execução."
fi

echo "-----------------------------"
echo "Verificando uso de disco..."

USO=$(df -h / | awk 'NR==2 {gsub("%","",$5); print $5}')

echo "Uso atual do disco: $USO%"

if [ "$USO" -gt 90 ]; then
    echo "[CRÍTICO] Uso acima de 90%."
elif [ "$USO" -gt 70 ]; then
    echo "[ALERTA] Uso acima de 70%."
else
    echo "[OK] Uso dentro do limite."
fi

echo "-----------------------------"
echo "Analisando processos do usuário..."

USER=$(whoami)

TOTAL=$(ps -u $USER | wc -l)
TOTAL=$((TOTAL - 1))

echo "Total de processos do usuário $USER: $TOTAL"

echo "Top 5 processos que mais usam memória:"
ps -u $USER -o pid,rss,comm --sort=-rss | head -n 6