import os
import re
import json
from pathlib import Path

# Caminho da pasta onde estão os posts
POSTS_DIR = Path("posts")
SAIDA_JSON = Path("docs/posts.json")  # Agora aponta para a pasta docs

def extract_post_metadata(qmd_file: Path):
    content = qmd_file.read_text(encoding="utf-8")
    title_match = re.search(r"title:\s*\"(.+?)\"", content)
    tags_match = re.search(r"tags:\s*\[(.*?)\]", content, re.DOTALL)
    if title_match and tags_match:
        title = title_match.group(1)
        tags_raw = tags_match.group(1)
        tags = [tag.strip().strip('"').strip("'") for tag in tags_raw.split(",")]
        href = str(qmd_file.with_suffix(".html")).replace("\\", "/")  # <<<<< alterado aqui
        return {"title": title, "href": href, "tags": tags}
    return None

def coletar_posts():
    posts_metadata = []
    for root, _, files in os.walk(POSTS_DIR):
        for file in files:
            if file.endswith(".qmd"):
                full_path = Path(root) / file
                metadata = extract_post_metadata(full_path)
                if metadata:
                    posts_metadata.append(metadata)
    return posts_metadata

def salvar_json(posts):
    # Garante que a pasta docs/ exista
    SAIDA_JSON.parent.mkdir(parents=True, exist_ok=True)
    with SAIDA_JSON.open("w", encoding="utf-8") as f:
        json.dump(posts, f, indent=2, ensure_ascii=False)
    print(f"✅ {len(posts)} posts salvos em {SAIDA_JSON}")

if __name__ == "__main__":
    posts = coletar_posts()
    salvar_json(posts)

