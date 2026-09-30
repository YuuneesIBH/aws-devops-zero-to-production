# 2. Linux for operators

Linux separates processes and exposes files, sockets and devices through a hierarchy. `/etc` commonly holds system configuration, `/var/log` logs, `/home` user files and `/proc` live process information. Absolute paths start at `/`; relative paths start at the current directory. `pwd`, `ls -la`, `cd`, `find` and `du -sh` answer where you are and what occupies storage.

Permissions encode owner, group and other read/write/execute bits. `chmod 600 file` restricts a private file to its owner. `chown user:group file` changes ownership. Use `sudo` only for commands needing elevated privilege; do not make every file writable to everyone. `id` shows your identity. Environment variables are process inputs, not a safe secret store or durable configuration by themselves.

`ps aux`, `top`, `kill` and `systemctl status NAME` inspect processes and services. `journalctl -u NAME --since '10 minutes ago'` reads service logs on a systemd host. `df -h` checks filesystem capacity; `du -sh PATH` estimates directory use; `free -h` checks memory. `ss -ltnp` identifies listeners. `lsof -i :8080` may identify the owner of a port. Availability and exact output vary by distribution.

Pipes pass output between programs: `journalctl -u app | grep ERROR`. Redirection saves it: `journalctl -u app > app.log`. `awk` extracts fields; `sed` edits streams; `tar` and `gzip` archive and compress. Quote variables in Bash: `"$path"` keeps spaces together. Use `curl -v` to inspect an HTTP exchange; `ssh` establishes a secure remote shell when network and identity policy allow it. `cron` runs scheduled tasks, but service-specific schedulers may be more suitable in containers.

## Failure walk: process runs, users cannot connect

1. `systemctl status app` and `journalctl -u app -n 100` establish whether process is healthy.
2. `ss -ltnp` checks listening address and port. `127.0.0.1:8080` accepts local traffic only.
3. `curl -v http://127.0.0.1:8080/health` tests local app behavior.
4. `ip addr` and `ip route` inspect interfaces and routes; then check host firewall and upstream load balancer.

Do not change a firewall before identifying the missing path. Check host and cloud rules separately.

## Knowledge check

Why can a service return 200 locally but time out remotely? What does write permission on a directory allow? Which command separates disk exhaustion from high memory use?

Further reading: [GNU Bash manual](https://www.gnu.org/software/bash/manual/), [systemd manual](https://www.freedesktop.org/software/systemd/man/latest/).
