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
        max_memory_restart: '1G',
        min_uptime: 20000,
      },
      {
        name: 'sidekiq',
        cwd: '/home/decidim/app',
        script: 'bundle',
        args: 'exec sidekiq',
        interpreter: 'ruby',
        restart_delay: 30000,
        max_memory_restart: '700M',
        min_uptime: 20000,
      }
    ],
  };
  