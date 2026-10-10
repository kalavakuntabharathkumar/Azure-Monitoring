# Azure Files backup and restore SOP

## Protection
1. Confirm the storage account and file share are in a supported region and configuration.
2. Create or select a Recovery Services vault and a daily Azure Files backup policy.
3. Set retention to 30 days and enable protection for the intended share.
4. Confirm the share appears as a protected backup item and inspect the latest recovery point.

## Restore verification
1. Restore to a separate destination share or account to avoid overwriting production data.
2. Mount or download the restored files to a controlled test path.
3. Run `Verify-Restore.ps1 -SourcePath <original> -RestoredPath <restored>`.
4. Save command output and the recovery point timestamp with the change record.
5. Repeat at least three times across distinct recovery points before accepting the operational procedure.

Keep restore credentials and storage keys out of scripts and logs. Follow the organization's approval process before production restores.
