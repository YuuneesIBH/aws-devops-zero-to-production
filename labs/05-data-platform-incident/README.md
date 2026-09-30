# Lab 05: healthy API, stale customer data

**Time:** 45–60 minutes. **Cost:** none. **Access:** local reading and a terminal for note-taking; no cloud account or customer data. This is a fictional incident modeled on common data-platform failure modes.

## Scenario

At 10:12 a customer reports that new invoices are absent from a dashboard. The UI loads and the API returns HTTP 200. A Kubernetes Deployment has two Ready Pods. The last successful invoice sync was 08:00, while syncs normally run every 15 minutes. A pipeline run at 08:15 returned HTTP 429 from the source after page 4 of 12. It retried three times and then failed. The 08:30 and later runs were skipped because the job lock remained held. At 10:00 an operator manually restarted the worker. A new run began from a checkpoint saved after page 4. The source API can return the same invoice on adjacent pages when records are updated during pagination.

## Your task

Write a short incident note before reading the [solution](solution.md):

1. State the affected user promise and the first signal that should have alerted the team.
2. List evidence you need: run IDs, lock owner/expiry, source response headers, checkpoint value, target row counts, recent changes and whether other tenants are affected.
3. Give a safe immediate mitigation. Include a condition under which you would **not** blindly replay all pages.
4. Design a durable fix for rate limits, lock expiry, checkpoint commit and duplicate pages.
5. Define two tests and one alert. Include how you verify dashboard freshness after recovery.

Use the [hints](hints.md) only if stuck. No infrastructure cleanup is needed because this lab creates none.

## Knowledge check

1. Why do Ready Pods and HTTP 200 fail to prove that invoices are current?
2. When is it safe to move the pipeline checkpoint past a page?
3. What makes replay after a worker crash safe, and when can it still cause harm?
