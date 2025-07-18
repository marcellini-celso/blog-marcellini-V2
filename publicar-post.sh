#!/bin/bash

# Nome do arquivo (sem extensão) passado como argumento
ARQUIVO="$1"

if [ -z "$ARQUIVO" ]; then
  echo "Uso: ./publicar-post.sh nome-do-arquivo (sem .qmd)"
  exit 1
fi

# Renderiza o arquivo .qmd
echo "Renderizando $ARQUIVO.qmd..."
quarto render "$ARQUIVO.qmd"

# Verifica se o HTML foi gerado na pasta docs/
if [ ! -f "docs/$ARQUIVO.html" ]; then
  echo "Erro: docs/$ARQUIVO.html não encontrado. A renderização falhou?"
  exit 2
fi

# Adiciona e faz commit dos arquivos
echo "Adicionando e comitando arquivos..."
git add "$ARQUIVO.qmd" "docs/$ARQUIVO.html"
git commit -m "Publicar post: $ARQUIVO"
git push origin main

echo "✅ Post publicado com sucesso: docs/$ARQUIVO.html"
