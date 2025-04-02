FROM octree/voca-decidim:0.29-bullseye AS assets
ENV NODE_ENV=development

WORKDIR /home/decidim/app
COPY . $ROOT

RUN NODE_MAJOR_VERSION=$(cut -d '.' -f1 /home/decidim/app/.node-version) \
    && curl -fsSL https://deb.nodesource.com/setup_$NODE_MAJOR_VERSION.x | bash - \
    && if dpkg -l | grep -qw nodejs; then apt-get purge -y nodejs; fi \
    && apt-get update -yq \
    && apt-get install -yq --no-upgrade nodejs \
    && export SECRET_KEY_BASE=assets \
    && npm install \
    && bundle config set path "$ROOT/vendor" \
    && bundle config set without "development:test" \
    && bundle config set no_cache true \
    && bundle config set deployment false \
    && bundle config set frozen false \
    && rm voca/Gemfile.lock \
    && bundle install \
    && bin/patch-gemlock \
    && bundle config set deployment true \
    && bundle config set frozen true \
    && bundle exec rails assets:precompile \
    && rm -rf node_modules .npm .bundle \
    && rm -rf /usr/local/bundle/cache 

FROM octree/voca-decidim:0.29-bullseye
ENV PM2_RUN="decidim,daily,monthly" \
  ROOT="/home/decidim/app" \
  NODE_ENV=development \
  RAILS_ENV=production

WORKDIR $ROOT
# Configure bundle
RUN  bundle config set path "$ROOT/vendor" \
  && bundle config set without "development:test" \
  && bundle config set no_cache true \
  && bundle config set deployment true \
  && bundle config set frozen true \
  && rm -rf vendor voca/Gemfile.lock \
  && rm -rf db/migrate/* 

COPY ./contrib/01_mautic_entrypoint /docker-entrypoint.d/01_mautic_entrypoint
COPY ./contrib/99_recompile /docker-entrypoint.d/99_recompile
COPY . $ROOT

RUN NODE_MAJOR_VERSION=$(cut -d '.' -f1 /home/decidim/app/.node-version) \
    && curl -fsSL https://deb.nodesource.com/setup_$NODE_MAJOR_VERSION.x | bash - \
    && if dpkg -l | grep -qw nodejs; then apt-get purge -y nodejs; fi \
    && apt-get update -yq \
    && apt-get install -yq --no-upgrade nodejs nginx \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log \
    && rm -rf Gemfile.lock Gemfile node_modules .npm .bundle yarn.lock .yarn \
    && rm -rf /usr/local/bundle/cache \
    && ln -s voca/Gemfile.lock ./Gemfile.lock \
    && ln -s voca/Gemfile ./Gemfile
COPY --from=assets /home/decidim/app/public/decidim-packs /home/decidim/app/public/decidim-packs
COPY --from=assets /home/decidim/app/vendor /home/decidim/app/vendor
COPY --from=assets /home/decidim/app/voca/Gemfile.lock /home/decidim/app/voca/Gemfile.lock
COPY ./contrib/nginx/nginx.conf /etc/nginx/nginx.conf

CMD ["pm2-runtime", "start", "config/ecosystem.config.js", "--only", "$PM2_RUN"]
