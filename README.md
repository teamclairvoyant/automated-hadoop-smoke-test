# Automated Hadoop Smoke Test

## This is the smoke test automation module for Hadoop.

### Goals

These are basic smoke tests to be used to determine basic functionality of the various parts of a Hadoop cluster (both Secured and non Secured). One might use these when setting up a new cluster or after a cluster upgrade.


Step 1: Check configuration file in conf folder.

	Before running the main script first edit the configuration file

		Step 1.1: Add proper paths and locations

		Step 1.2: Add Kerberos Keytabs

		Step 1.3: Add cluster type

		Step 1.4: Add whether the security is enabled or no

		Step 1.5: Add proper flags for services


Step 2: Run SmokeTest.sh from its home location. (because we are using relative paths in the scripts)

`sh SmokeTest.sh`

Step 3: Log file in the log folder (logfile.log) contains the logs after executing each service.

Step 4: Summary file in the log folder (SummaryReport.txt) contains the summary after executing each services.
