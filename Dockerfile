FROM octree/voca-decidim:0.27
ENV PM2_RUN="decidim,sidekiq" \
  ROOT="/home/decidim/app" \
  NODE_ENV=development \
  RAILS_ENV=production

WORKDIR $ROOT
RUN apt-get update -yq \
# Install native deps
  && apt-get install -yq nginx \ 
# Clean installation clutters
  && apt-get clean \
  && apt-get autoremove -y  \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log \
  && rm -rf /usr/local/bundle/cache  \
# Configure bundle
  && cd $ROOT \
  && bundle config set path "vendor" \
  && bundle config set without "development:test" \
  && bundle config set no_cache "true" \
  && bundle config set deployment "false" \
  && rm -rf vendor voca/Gemfile.lock \
  && rm -rf db/migrate/*

COPY ./contrib/01_mautic_entrypoint /docker-entrypoint.d/01_mautic_entrypoint
COPY ./contrib/99_recompile /docker-entrypoint.d/99_recompile
COPY --chown=decidim:decidim ./contrib/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --chown=decidim:decidim . $ROOT
RUN export RAILS_SECRET_KEY_BASE=assets \
  && bundle install \
  && bundle config set deployment "true"

  CMD ["pm2-runtime", "start", "config/ecosystem.config.js", "--only", "$PM2_RUN"]
