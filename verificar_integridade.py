import json
from pathlib import Path

ARQUIVO_JSON = Path("docs/posts.json")

def carregar_posts():
    if not ARQUIVO_JSON.exists():
        print("❌ Arquivo posts.json não encontrado.")
        return []
    with open(ARQUIVO_JSON, encoding="utf-8") as f:
        return json.load(f)

def verificar_integridade(posts):
    erros = []
    for post in posts:
        caminho = post.get("href", "desconhecido")
        if not post.get("title"):
            erros.append(f"❌ Post sem título: {caminho}")
        if not post.get("tags"):
            erros.append(f"⚠️ Post sem tags: {caminho}")
        if not post.get("date"):
            erros.append(f"⚠️ Post sem data: {caminho}")
    return erros

def main():
    posts = carregar_posts()
    if not posts:
        return
    erros = verificar_integridade(posts)
    if erros:
        print("🚨 Problemas encontrados:")
        for erro in erros:
            print(erro)
        print("\n💡 Corrija os problemas antes de publicar.")
    else:
        print("✅ Todos os posts passaram na verificação de integridade.")

if __name__ == "__main__":
    main()