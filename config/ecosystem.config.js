module.exports = {
    apps: [
      {
        name: 'decidim',
        cwd: '/home/decidim/app',
        script: 'bundle',
        args: 'exec puma',
        interpreter: 'ruby',
        restart_delay: 30000,
        max_restarts: 10,
        min_uptime: 20000,
        max_size: '10M'
      },
      {
        name: 'sidekiq',
        cwd: '/home/decidim/app',
        script: 'bundle',
        args: 'exec sidekiq',
        interpreter: 'ruby',
        restart_delay: 30000,
        max_restarts: 10,
        min_uptime: 20000,
        max_size: '10M'
      },
      {
        name: 'daily',
        script: 'daily', 
        cron_restart: '0 7 * * *', 
        autorestart: false,
        log_date_format: 'YYYY-MM-DD HH:mm Z',
        error_file: './log/daily-err.log',
        out_file: './log/daily-out.log',
        max_size: '2M',
        time: true,
        max_size: '10M'
      },
    ],
    deploy: {
      production: {
        post_deploy:
          'pm2 install pm2-logrotate && pm2 set pm2-logrotate:max_size 10M && pm2 set pm2-logrotate:retain 30',
      },
    },
  };
  