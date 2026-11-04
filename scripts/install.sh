#!/usr/bin/env bash
# Copia as skills deste repositório para uma pasta de skills do Claude Code.
# Uso: ./scripts/install.sh [destino] [skill ...]
#   destino padrão: ~/.claude/skills (instalação global)
#   sem nomes de skill: instala todas as pastas em skills/
set -euo pipefail

raiz="$(cd "$(dirname "$0")/.." && pwd)"
origem="$raiz/skills"
destino="${1:-$HOME/.claude/skills}"
shift || true

if [ "$#" -gt 0 ]; then
  nomes=("$@")
else
  nomes=()
  for d in "$origem"/*/; do nomes+=("$(basename "$d")"); done
fi

mkdir -p "$destino"
for nome in "${nomes[@]}"; do
  if [ ! -f "$origem/$nome/SKILL.md" ]; then
    echo "Ignorada: '$nome' não existe em skills/ ou não tem SKILL.md" >&2
    continue
  fi
  mkdir -p "$destino/$nome"
  cp -R "$origem/$nome/." "$destino/$nome/"
  echo "Instalada: $nome -> $destino/$nome"
done
