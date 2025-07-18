#!/bin/bash

# Mensagem de commit como argumento (opcional)
MENSAGEM="$1"

if [ -z "$MENSAGEM" ]; then
  MENSAGEM="Atualizações no blog"
fi

# Renderiza todo o projeto
echo "🛠️ Renderizando site completo com Quarto..."
quarto render

# Adiciona tudo que foi alterado
echo "📦 Adicionando alterações ao Git..."
git add .

# Faz o commit
echo "📝 Comitando com mensagem: '$MENSAGEM'"
git commit -m "$MENSAGEM"

# Envia para o repositório remoto
echo "🚀 Enviando alterações para o GitHub..."
git push origin main

echo "✅ Atualizações publicadas com sucesso!"
