# Pin npm packages by running ./bin/importmap

pin "application"

# ✅ これに置き換える（Popper同梱のバンドル）
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"