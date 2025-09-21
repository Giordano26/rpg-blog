#!/bin/bash
echo "🚀 Iniciando deploy..."

CURRENT_BRANCH=$(git branch --show-current)

TEMP_DIR="/tmp/static_deploy_$$"
mkdir -p "$TEMP_DIR"

rails server -d
sleep 5

wget -q --recursive --page-requisites --html-extension --convert-links \
  --domains=localhost --no-parent --directory-prefix="$TEMP_DIR" \
  http://localhost:3000/

pkill -f "rails server"

if [ -d "$TEMP_DIR/localhost:3000" ]; then
  echo "📁 Arquivos gerados, fazendo deploy..."

  git checkout gh-pages

  rm -rf *.html assets/ images/ stylesheets/ javascripts/ 2>/dev/null

  cp -r "$TEMP_DIR"/localhost:3000/* . 2>/dev/null

  if [ "$(ls -A .)" ]; then
    git add .
    git commit -m "Deploy $(date '+%Y-%m-%d %H:%M')"
    git push origin gh-pages
    echo "✅ Push realizado!"
  else
    echo "❌ Nenhum arquivo copiado!"
  fi

  git checkout "$CURRENT_BRANCH"
else
  echo "❌ Falha ao gerar arquivos estáticos"
fi

rm -rf "$TEMP_DIR"

echo "Deploy finalizado!"
