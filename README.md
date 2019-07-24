# Automated Hadoop Smoke Test

## This is the smoke test automation module for Hadoop.

### Objective

These are basic smoke tests to be used to determine basic functionality of the various parts of a Hadoop cluster (both Secured and non Secured). One might use these when setting up a new cluster or after a cluster upgrade.

### Prerequistes
- Ensure the machine has command line access to the gateway role instances for services being tested (i.e. hdfs, hive, spark-shell, etc).

- Ensure the machine has the ability to obtain a ticket granting token if using a kerberized cluster.

### Deployment

Step 1: Download the GitHub repository.

Step 2: Unzip the repository in the /tmp directory.

### Configuration

- Modify the configuration file (conf/SmokeConfig.config):

		Step 1: Add proper paths and locations

		Step 2: Add whether the security is enabled or no

		Step 3: Add proper flags for services

### Execution

- Execute SmokeTest.sh.

```
sh SmokeTest.sh
```

### Note

- Hortonworks Data Platform (HDP) comes pre-loaded with Spark2. The "Spark" test is able to test the service. Kindly set "Spark2" test to false since HDP doesn't have access to "spark2-shell."

```
#SPARK active or not
SPARK="true"

#SPARK2 active or not
SPARK2="false"
```