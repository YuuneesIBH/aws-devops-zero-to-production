# Application cannot reach database

**Symptoms:** connection timeout, refusal, TLS error or authentication error. **Impact:** requests needing data fail; writes may queue or be lost depending on app design.

**Immediate checks:** identify exact error and start time. Check RDS status, endpoint/DNS and app logs. From the app network context test `nc -vz DB_HOST 5432` for PostgreSQL or the configured port. Review app and DB security groups, subnet/NACL path, TLS configuration, credential source and database connection count. Do not expose passwords.

**Possible causes:** wrong endpoint/port, blocked path, expired credential, DB failover, exhausted connections or certificate change. **Mitigation:** restore known-good config or network rule after review; reduce connection pressure; fail over only under an incident plan. Verify a read and safe write through the app.

**Long-term fixes:** connection pooling, rotation tests, alerts on failures/connection usage, restore drills. **Escalate** for suspected data loss, prolonged outage or unavailable DB instance.
