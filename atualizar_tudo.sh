#!/bin/bash

# Função de log com timestamp
log() {
  echo "[`date +"%Y-%m-%d %H:%M:%S"`] $1"
}

log "🔄 Atualizando últimos posts..."
bash atualizar-ultimos-posts.sh || { echo "❌ Falha ao atualizar últimos posts."; exit 1; }

log "📦 Gerando arquivo posts.json..."
python3 gerar_posts_json.py || { echo "❌ Falha ao gerar posts.json."; exit 1; }

log "🏷️ Atualizando tags..."
bash atualizar_tags.sh || { echo "❌ Falha ao atualizar tags."; exit 1; }

# python verificar_integridade.py || { echo "❌ Falha na verificação de integridade."; exit 1; }
log "✅ Atualização completa!"
