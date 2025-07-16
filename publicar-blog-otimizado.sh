# Verifica se há alterações não commitadas
if ! git diff-index --quiet HEAD --; then
  echo "⚠️  Você tem alterações não commitadas."
  echo "Escolha uma opção:"
  echo "[1] Fazer commit das alterações"
  echo "[2] Fazer stash das alterações temporariamente"
  echo "[3] Descartar as alterações (reset)"
  echo "[4] Cancelar"

  read -p "Digite o número da opção desejada: " escolha

  case "$escolha" in
    1)
      echo "📦 Preparando commit..."
      git add .
      read -p "Digite a mensagem do commit: " msg
      git commit -m "$msg"
      ;;
    2)
      echo "📦 Fazendo stash das alterações..."
      git stash
      ;;
    3)
      echo "⚠️ Descartando alterações..."
      git reset --hard
      ;;
    4)
      echo "❌ Cancelado pelo usuário."
      exit 1
      ;;
    *)
      echo "❌ Opção inválida. Cancelando."
      exit 1
      ;;
  esac
fi

#!/bin/bash
start_time=$(date +%s)


# Função para exibir mensagens com timestamp
log() {
  echo "[`date +"%Y-%m-%d %H:%M:%S"`] $1"
}

log "Iniciando publicação do blog..."

# Verifica se o Quarto está instalado
if ! command -v quarto &> /dev/null; then
  log "❌ Erro: o Quarto não está instalado ou não está no PATH."
  exit 1
fi

# Renderiza o site diretamente em docs/
log "Renderizando o site (saida: docs/)..."
if ! quarto render; then
  log "❌ Falha ao renderizar o site."
  exit 1
fi

# Verifica se há mudanças
if git diff --quiet && git diff --cached --quiet; then
  log "Nenhuma mudança detectada. Nada para publicar."
  exit 0
fi

# Adiciona apenas os arquivos relevantes
log "Adicionando arquivos relevantes ao Git..."
git add docs _quarto.yml

# Adiciona arquivos .qmd, .md, .ipynb se existirem
shopt -s nullglob
arquivos=( *.qmd *.md *.ipynb )
if [ ${#arquivos[@]} -gt 0 ]; then
  git add "${arquivos[@]}" || {
    log "❌ Erro ao adicionar arquivos de conteúdo ao Git."
    exit 1
  }
fi

# Solicita mensagem de commit
read -p "Digite a mensagem de commit: " mensagem
git commit -m "$mensagem" || {
  log "❌ Erro ao realizar o commit. Verifique se há mudanças reais."
  exit 1
}

# Push
log "Enviando alterações para a branch main..."
if ! 
# Verificar se há alterações não commitadas
if [[ -n $(git status --porcelain) ]]; then
  echo "⚠️ Você tem alterações não commitadas."
  echo "💡 Faça commit, stash ou descarte antes de continuar."
  exit 1
fi

# Atualizar a branch local com rebase
echo "📥 Executando git pull --rebase para sincronizar com o repositório remoto..."
git pull origin main --rebase || { echo "❌ Erro ao executar git pull --rebase."; exit 1; }


git push origin main; then
  exit 1
fi

log "✅ Publicação concluída com sucesso na branch 'main' (pasta /docs)."
