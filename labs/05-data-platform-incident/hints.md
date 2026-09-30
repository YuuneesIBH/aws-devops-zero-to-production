# Hints

1. Availability of the UI/API is a different signal from data freshness.
2. HTTP 429 can include `Retry-After`; the source's published limits and job concurrency matter.
3. A lock without a lease/expiry can block future jobs forever after a worker failure.
4. A checkpoint should represent data safely committed to the target, not merely fetched from the source.
5. Upsert by a stable source record ID makes replays less dangerous, but updates and deletions still need ordering rules.
