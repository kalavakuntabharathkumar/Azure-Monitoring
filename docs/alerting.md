# Alert design and test plan

The alert set should cover availability, HTTP 5xx rate, CPU percentage, memory percentage, and storage capacity. Metric alerts are appropriate for numeric platform metrics; use scheduled-query alert rules when the condition is expressed in KQL. Tune thresholds and evaluation windows for the app's normal baseline to avoid noisy alerts.

## Load-test validation
1. Capture a baseline for each metric.
2. Generate controlled traffic in a non-production environment.
3. Confirm each alert transitions to Fired and that the action group receives the notification.
4. Record trigger time, evaluation window, notification time, and recovery time.
5. Reset the environment and confirm alerts return to Resolved.

The under-five-minute detection target is a test objective, not a guarantee; actual timing depends on metric ingestion and evaluation frequency.
