# Sample Rails App (Rails 8 + Docker + PostgreSQL)

Docker を使って Rails アプリを立ち上げ、`http://localhost` でデフォルトページを表示するまでの手順です。

---

## 🚀 環境構築手順

### 1. プロジェクトディレクトリを作成

```bash
mkdir -p ~/RailsProjects/sample-rails-app
cd ~/RailsProjects/sample-rails-app
```

### 2. Dockerfile を作成

```dockerfile
FROM ruby:3.4.6

ARG APP_ROOT='/usr/src/sample-rails-app'

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs
RUN apt-get install -y vim
RUN npm install -g yarn

WORKDIR $APP_ROOT

COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle install

COPY . $APP_ROOT
```

### 3. docker-compose.yml を作成

```yaml
services:
  db:
    image: postgres:14-alpine
    volumes:
      - postgres-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}

  web:
    build: .
    volumes:
      - .:/usr/src/sample-rails-app
      - bundle:/usr/local/bundle
    ports:
      - "80:3000"
    environment:
      RAILS_ENV: "development"
      DATABASE_HOST: "db"
      DATABASE_USER: "postgres"
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    depends_on:
      - db
    tty: true
    entrypoint: []
    stdin_open: true
    command: bash -lc "rm -f tmp/pids/server.pid && exec bin/rails s -b 0.0.0.0 -p 3000"

volumes:
  postgres-data:
  bundle:
```

### 4. Gemfile / Gemfile.lock を作成

```ruby
# Gemfile
source "https://rubygems.org"
gem "rails", "~> 8.0"
```

```bash
# Gemfile.lock
touch Gemfile.lock
```

### 5. .env を作成（※Git には上げない）

```env
POSTGRES_PASSWORD=yourpassword
```

### 6. ビルド

```bash
docker compose build
```

### 7. Rails アプリの生成

```bash
docker compose run --rm web bash -lc 'rails new . --force --database=postgresql'
```

### 8. bundle install

```bash
docker compose run --rm web bundle install
```

### 9. database.yml を修正（ENV 連動）

`config/database.yml` の `default` を次のように変更：

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV.fetch("DATABASE_HOST", "db") %>
  username: <%= ENV.fetch("DATABASE_USER", "postgres") %>
  password: <%= ENV.fetch("POSTGRES_PASSWORD", "") %>
  pool: 5

development:
  <<: *default
  database: sample_rails_app_development

test:
  <<: *default
  database: sample_rails_app_test

production:
  <<: *default
  database: sample_rails_app_production
```

### 10. コンテナ起動

```bash
docker compose up -d
```

### 11. DB 作成 & マイグレーション

```bash
docker compose exec web bin/rails db:create
docker compose exec web bin/rails db:migrate
```

### 12. ブラウザで確認

[http://localhost](http://localhost) にアクセスすると **Rails の Welcome ページ** が表示されます 🎉
