@rest
Feature: [Install Spark Dispatcher] Installing Spark Dispatcher

    Background:
        Given I open a ssh connection to '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'

    Scenario:[Spark dispacher Installation][01]Basic Instalation Spark dispacher
        Given I create file 'SparkDispacherInstallation.json' based on 'schemas/SparkDispacher/BasicSparkDispacher.json' as 'json' with:
            |   $.service.name                                  |  UPDATE      | spark-fw                        | n/a     |
            |   $.service.tenant_name                           |  UPDATE      | spark-fw                        | n/a     |
          #Copy DEPLOY JSON to DCOS-CLI
        When I outbound copy 'target/test-classes/SparkDispacherInstallation.json' through a ssh connection to '/dcos'
          #Start image from JSON
        And I run 'dcos package describe --app --options=/dcos/SparkDispacherInstallation.json spark-dispatcher >> /dcos/SparkDispacherInstallationMarathon.json' in the ssh connection
        And I run 'sed -i -e 's|"image":.*|"image": "${SPARK_DOCKER_IMAGE}:${STRATIO_SPARK_VERSION}",|g' /dcos/SparkDispacherInstallationMarathon.json' in the ssh connection
        And I run 'dcos marathon app add /dcos/SparkDispacherInstallationMarathon.json' in the ssh connection
          #Check Crossdata is Running
        Then in less than '500' seconds, checking each '20' seconds, the command output 'dcos task | grep spark-fw | grep R | wc -l' contains '1'
          #Find task-id if from DCOS-CLI
        And in less than '300' seconds, checking each '20' seconds, the command output 'dcos marathon task list spark-fw | grep spark-fw | awk '{print $2}'' contains 'True'
        And I run 'dcos marathon task list spark-fw | awk '{print $5}' | grep spark-fw | head -n 1' in the ssh connection and save the value in environment variable 'sparkTaskId'
          #DCOS dcos marathon task show check healtcheck status
        Then in less than '300' seconds, checking each '10' seconds, the command output 'dcos marathon task show !{sparkTaskId} | grep TASK_RUNNING | wc -l' contains '1'
        Then in less than '300' seconds, checking each '10' seconds, the command output 'dcos marathon task show !{sparkTaskId} | grep healthCheckResults | wc -l' contains '1'
        Then in less than '300' seconds, checking each '10' seconds, the command output 'dcos marathon task show !{sparkTaskId} | grep  '"alive": true' | wc -l' contains '1'


    Scenario: [Spark dispacher Installation][02] Uninstall Spark Dispacher
        Given I open a ssh connection to '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
        Given I run 'dcos marathon app remove spark-fw' in the ssh connection
        Then in less than '300' seconds, checking each '10' seconds, the command output 'dcos task | grep spark-fw | wc -l' contains '0'