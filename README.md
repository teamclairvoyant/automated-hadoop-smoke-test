# Automated Hadoop Smoke Test

## This is the smoke test automation module for Hadoop.

### Goals

These are basic smoke tests to be used to determine basic functionality of the various parts of a Hadoop cluster (both Secured and non Secured). One might use these when setting up a new cluster or after a cluster upgrade.

### Notes

- HDP comes pre-loaded with Spark2. The "Spark" test is able to test the service. Kindly set "Spark2" test to false since HDP doesn't have access to "spark2-shell."

```
#SPARK active or not
SPARK="true"

#SPARK2 active or not
SPARK2="false"
```

### Configuration

- Check configuration file (SmokeConfig.config) in conf folder.

	Before running the main script (SmokeTest.sh), modify the configuration file:

		Step 1.1: Add proper paths and locations

		Step 1.2: Add Kerberos Keytabs

		Step 1.3: Add whether the security is enabled or no

		Step 1.4: Add proper flags for services


### Deployment Process

Step 1: Download the GitHub repository.

Step 2: Unzip the repository in the /tmp directory.

Step 3: Update the values in the configuration file (follow the steps listed above).

Step 4: Execute SmokeTest.sh.
