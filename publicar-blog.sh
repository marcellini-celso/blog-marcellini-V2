#!/bin/bash
echo "🔍 Verificando status do Git..."
git status

echo "➕ Adicionando todos os arquivos modificados..."
git add .

echo "📝 Criando commit..."
git commit -m "$1"

echo "⬇️ Fazendo pull com rebase..."
git pull --rebase origin main

echo "🚀 Enviando para o GitHub..."
git push origin main

