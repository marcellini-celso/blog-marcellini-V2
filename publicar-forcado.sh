#!/bin/bash

start_time=$(date +%s)

log() {
  echo "[`date +"%Y-%m-%d %H:%M:%S"`] $1"
}

log "🛠️ Publicação forçada do blog..."

# Abortar rebase se estiver em andamento
if [ -d .git/rebase-apply ] || [ -d .git/rebase-merge ]; then
  log "⚠️ Rebase detectado — abortando..."
  git rebase --abort
fi

# Garantir que estamos em um repositório Git
if [ ! -d .git ]; then
  log "❌ Este diretório não é um repositório Git."
  exit 1
fi

# Verifica se Quarto está instalado
if ! command -v quarto &>/dev/null; then
  log "❌ Quarto não está instalado."
  exit 1
fi

# Renderizar blog
log "⚙️ Renderizando site com Quarto (pasta docs/)..."
quarto render || { log "❌ Erro ao renderizar com Quarto."; exit 1; }

# Adicionar arquivos relevantes
log "📦 Adicionando arquivos modificados..."
git add docs _quarto.yml

shopt -s nullglob
arquivos=( *.qmd *.md *.ipynb )
if [ ${#arquivos[@]} -gt 0 ]; then
  git add "${arquivos[@]}"
fi

read -p "📝 Mensagem do commit: " mensagem
git commit -m "$mensagem" || log "ℹ️ Nenhuma mudança para commit."

# Garantir branch main
git branch -M main

# Push forçado
log "🚀 Enviando para GitHub com --force..."
git push --force origin main || { log "❌ Falha ao forçar o push."; exit 1; }

end_time=$(date +%s)
log "✅ Publicação forçada concluída em $((end_time - start_time)) segundos."
