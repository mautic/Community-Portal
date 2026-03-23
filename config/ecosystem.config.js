module.exports = {
  apps: [
    {
      name: "decidim",
      script: "/home/decidim/bin/rails",
      args: "server -b 0.0.0.0",
      interpreter: "ruby",
      kill_timeout: 3000,
      log_date_format: "YYYY-MM-DD HH:mm Z",
      combine_logs: true,
      merge_logs: true,
      time: true,
      out_file: "/var/log/run.log",
      error_file: "/var/log/run.log",
    },
    {
      name: "external_good_job",
      script: "/home/decidim/bin/good_job",
      args: "start",
      interpreter: "ruby",
      kill_timeout: 3000,
      log_date_format: "YYYY-MM-DD HH:mm Z",
      combine_logs: true,
      merge_logs: true,
      time: true,
      out_file: "/var/log/run.log",
      error_file: "/var/log/run.log",
    },
    {
      name: "snooze",
      script: "sleep",
      args: "infinity",
      interpreter: "bash",
      kill_timeout: 3000,
    },
    {
      name: "daily",
      script: "/home/decidim/bin/daily",
      cron_restart: "0 7 * * *", // Runs daily at 7 AM
      interpreter: "bash",
      autorestart: false,
      log_date_format: "YYYY-MM-DD HH:mm Z",
      time: true,
      out_file: "/var/log/run.log",
      error_file: "/var/log/run.log",
    },
    {
      name: "monthly",
      script: "/home/decidim/bin/monthly",
      cron_restart: "0 7 1 * *", // Runs monthly on the 1st at 7 AM
      interpreter: "bash",
      autorestart: false,
      log_date_format: "YYYY-MM-DD HH:mm Z",
      time: true,
      out_file: "/var/log/run.log",
      error_file: "/var/log/run.log",
    }
  ],

};
