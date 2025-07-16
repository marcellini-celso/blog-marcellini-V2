import unicodedata
import matplotlib.pyplot as plt
from wordcloud import WordCloud
import os

ARQUIVO_FREQ = "tags_freq.txt"
ARQUIVO_SAIDA = "nuvem_tags.png"

def carregar_frequencias(caminho):
    """Lê o arquivo de frequências e retorna um dicionário tag → contagem"""
    if not os.path.exists(caminho):
        print(f"❌ Arquivo '{caminho}' não encontrado.")
        return {}

    frequencias = {}
    with open(caminho, encoding="utf-8") as f:
        for linha in f:
            partes = linha.strip().split()
            if len(partes) >= 2:
                try:
                    count = int(partes[0])
                    tag = unicodedata.normalize("NFC", " ".join(partes[1:]).strip())
                    frequencias[tag] = count
                except ValueError:
                    print(f"⚠️ Erro ao converter linha: {linha}")
    return frequencias

def gerar_nuvem(frequencias, saida):
    """Gera a imagem da nuvem de palavras"""
    if not frequencias:
        print("⚠️ Nenhuma frequência válida encontrada.")
        return

    wc = WordCloud(
        width=1000,
        height=500,
        background_color="white",
        colormap="tab20c",
        font_path=None,  # pode definir um caminho específico de fonte aqui
        prefer_horizontal=0.8,
        margin=5
    )
    wc.generate_from_frequencies(frequencias)
    wc.to_file(saida)
    print(f"✅ Nuvem de tags salva como '{saida}'")

if __name__ == "__main__":
    freq = carregar_frequencias(ARQUIVO_FREQ)
    gerar_nuvem(freq, ARQUIVO_SAIDA)

