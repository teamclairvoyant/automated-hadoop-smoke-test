# Automated Hadoop Smoke Test

This is the smoke test automation module for Hadoop. Once downloaded and configured, you can execute basic smoke tests to determine basic functionality of the various services of a Hadoop cluster (both Secured and non Secured). One might use these when setting up a new cluster, after a cluster upgrade or after configuration change.

### Prerequisites
- Ensure the machine has command line access to the gateway role instances for services being tested (i.e. hdfs, hive, spark-shell, etc).

- Ensure the machine has the ability to obtain a ticket granting token if using a kerberized cluster.

### Deployment

 1. Download the GitHub repository.

 2. Unzip the repository in the /tmp directory.

### Configuration

- Modify the configuration file (conf/SmokeConfig.config):

	- Add proper flags for services (Use true/false)
		
	- Add proper flags for security configurations (Use true/false)

	- Add proper paths and locations	

### Execution

Execute SmokeTest.sh.

```
cd {AUTOMATED-SMOKE-TEST-HOME}
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

