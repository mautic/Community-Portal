FROM octree/voca-decidim:0.29-bullseye
ENV PM2_RUN="decidim,daily,monthly" \
  ROOT="/home/decidim/app" \
  NODE_ENV=development \
  RAILS_ENV=production

WORKDIR $ROOT
# Configure bundle
RUN  bundle config set path "$ROOT/vendor" \
  && bundle config set without "development:test" \
  && bundle config set no_cache "true" \
  && bundle config set deployment "true" \
  && rm -rf vendor voca/Gemfile.lock \
  && rm -rf db/migrate/* 

COPY ./contrib/01_mautic_entrypoint /docker-entrypoint.d/01_mautic_entrypoint
COPY ./contrib/99_recompile /docker-entrypoint.d/99_recompile
COPY --chown=decidim:decidim . $ROOT

RUN NODE_MAJOR_VERSION=$(cut -d '.' -f1 /home/decidim/app/.node-version) \
    && curl -fsSL https://deb.nodesource.com/setup_$NODE_MAJOR_VERSION.x | bash - \
    && if dpkg -l | grep -qw nodejs; then apt-get purge -y nodejs; fi \
    && apt-get update -yq \
    && apt-get install -yq --no-upgrade nodejs \
    && export SECRET_KEY_BASE=assets \
    && bundle config set deployment false \
    && bundle install \
    && patch-gemlock \
    && apt-get update -yq \
    # Install native deps
    && apt-get install -yq nginx \ 
    # Clean installation clutters
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log \
    && rm -rf node_modules .npm .bundle \
    && rm -rf /usr/local/bundle/cache 

COPY --chown=decidim:decidim ./contrib/nginx/nginx.conf /etc/nginx/nginx.conf

CMD ["pm2-runtime", "start", "config/ecosystem.config.js", "--only", "$PM2_RUN"]
