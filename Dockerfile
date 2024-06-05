FROM git.octree.ch:4567/decidim/vocacity/system/decidim-0.27
ENV PM2_RUN="decidim,sidekiq" \
  ROOT="/home/decidim/app" \
  NODE_ENV=development

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
  && bundle config set with "production" \
  && bundle config set no_cache "true" \
  && bundle config set deployment "false" \
  && rm -rf vendor Gemfile.lock \
  && rm -rf db/migrate/*

COPY ./contrib/01_mautic_entrypoint /docker-entrypoint.d/01_mautic_entrypoint
COPY --chown=decidim:decidim ./contrib/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --chown=decidim:decidim . $ROOT
RUN bundle install \
  # Recompile assets.
  && bundle exec rails decidim:webpacker:install \
  && bundle exec rails decidim_decidim_awesome:webpacker:install \
  && npm ci \
  && bundle exec rails assets:precompile \
  && rm -rf node_modules

CMD ["pm2-runtime", "start", "/home/decidim/app/config/ecosystem.config.js", "--only", "$PM2_RUN"]
