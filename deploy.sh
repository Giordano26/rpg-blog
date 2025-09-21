echo "Iniciando deploy..."

rails server -d # daemon mode
sleep 5

wget -q --recursive --page-requisites --html-extension --convert-links \
  --domains=localhost --no-parent --directory-prefix=static_site \
  http://localhost:3000/

pkill -f "rails server"

git checkout gh-pages
rm -rf *.html assets/ images/ stylesheets/ javascripts/ 2>/dev/null
cp -r static_site/localhost:3000/* . 2>/dev/null
rm -rf static_site/
git add .
git commit -m "Deploy $(date '+%Y-%m-%d %H:%M')"
git push origin gh-pages
git checkout main

echo "Deploy concluído!"
