#!/bin/bash

start_time=$(date +%s)

log() {
  echo "[`date +"%Y-%m-%d %H:%M:%S"`] $1"
}

log "🔧 Iniciando publicação do blog..."

# Verifica se a pasta é um repositório Git
if [ ! -d .git ]; then
  log "⚠️  Este diretório ainda não é um repositório Git. Inicializando..."
  git init || { log "❌ Erro ao inicializar o Git."; exit 1; }
fi

# Verifica se o remoto origin existe
if ! git remote get-url origin &>/dev/null; then
  read -p "🔗 Digite a URL do repositório remoto (ex: https://github.com/usuario/repo.git): " repo_url
  git remote add origin "$repo_url" || { log "❌ Erro ao adicionar o remoto."; exit 1; }
fi

# Verifica se há alterações não commitadas
if ! git diff-index --quiet HEAD --; then
  echo "⚠️  Você tem alterações não commitadas."
  echo "[1] Fazer commit das alterações"
  echo "[2] Fazer stash das alterações"
  echo "[3] Descartar alterações"
  echo "[4] Cancelar"
  read -p "Escolha: " escolha
  case "$escolha" in
    1) git add .; read -p "Mensagem do commit: " msg; git commit -m "$msg" ;;
    2) git stash ;;
    3) git reset --hard ;;
    4) echo "❌ Cancelado."; exit 1 ;;
    *) echo "❌ Opção inválida."; exit 1 ;;
  esac
fi

# Verifica se o Quarto está instalado
if ! command -v quarto &>/dev/null; then
  log "❌ Quarto não está instalado."
  exit 1
fi

log "⚙️  Renderizando site com Quarto (pasta docs/)..."
quarto render || { log "❌ Falha ao renderizar com Quarto."; exit 1; }

# Adiciona arquivos relevantes
log "📦 Adicionando arquivos..."
git add docs _quarto.yml

shopt -s nullglob
arquivos=( *.qmd *.md *.ipynb )
if [ ${#arquivos[@]} -gt 0 ]; then
  git add "${arquivos[@]}" || { log "❌ Erro ao adicionar arquivos."; exit 1; }
else
  log "ℹ️ Nenhum arquivo .qmd, .md ou .ipynb encontrado. Pulando essa etapa."
fi

read -p "📝 Mensagem do commit: " mensagem
git commit -m "$mensagem" || log "ℹ️ Nenhuma mudança para commit."

git branch -M main

log "🔄 Fazendo pull com rebase (se possível)..."
git pull origin main --rebase || log "⚠️ Pull com rebase falhou. Continuando..."

log "🚀 Enviando para GitHub..."
git push -u origin main || { log "❌ Falha no push."; exit 1; }

end_time=$(date +%s)
log "✅ Publicação concluída em $((end_time - start_time)) segundos."
