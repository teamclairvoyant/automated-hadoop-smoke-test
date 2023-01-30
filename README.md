# Automated Hadoop Smoke Tests

This is the smoke test automation module for Hadoop. It follows the documentation at [Hadoop Smoke Tests](https://github.com/teamclairvoyant/hadoop-smoke-tests). Once downloaded and configured, you can execute integration smoke tests to determine basic functionality of the various services of a Hadoop cluster (both Secured and non Secured). One might use these when setting up a new cluster, after a cluster upgrade, or after configuration change.

The goal of an Integration Smoke Test is not to thoroughly exercise the component, but rather to make sure it has basic operation. For example:

 * Can I get a directory listing from HDFS?
 * Can I write a file to HDFS?
 * Can I read that file back from HDFS?
 * Can I remove that file from HDFS?

## Prerequisites

- Ensure the machine has command line access to the gateway role instances for services being tested (i.e. hdfs, hive, spark-shell, etc).
- Ensure the machine has the ability to obtain a ticket granting ticket if using a Kerberized cluster.

## Deployment

 1. Download the GitHub repository.
 2. Unzip the repository in the `$HOME` directory.

## Configuration

Modify the configuration file (`conf/SmokeConfig.config`):

 - Enable the desired service tests (use true/false)
 - Configure the options for security (use true/false)
 - Configure dataset names, paths, and locations

## Execution

Execute SmokeTest.sh.

```
cd ./SmokeTest
./SmokeTest.sh
```

## Note

- Hortonworks Data Platform (HDP) comes pre-loaded with Spark2. The "Spark" test is able to test the service. Kindly set "Spark2" test to false since HDP doesn't have access to "spark2-shell."

```
# SPARK active or not
SPARK="true"

# SPARK2 active or not
SPARK2="false"
```
