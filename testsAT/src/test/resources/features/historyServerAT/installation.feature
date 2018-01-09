@rest
Feature: [Install Spark History Server] Installing Spark Dispatcher

    Scenario: [Install Spark History Server][01] Install Spark Dispatcher with Calico and Mesos security

        Given I open a ssh connection to '${BOOTSTRAP_IP}' with user '${REMOTE_USER:-operador}' using pem file 'src/test/resources/credentials/key.pem'
        And I run 'grep -Po '"root_token":"(\d*?,|.*?[^\\]")' /stratio_volume/vault_response | awk -F":" '{print $2}' | sed -e 's/^"//' -e 's/"$//'' in the ssh connection and save the value in environment variable 'vaultToken'
        And I authenticate to DCOS cluster '${DCOS_IP}' using email '${DCOS_USER}' with user '${REMOTE_USER:-operador}' and pem file 'src/test/resources/credentials/key.pem'
        And I open a ssh connection to '${DCOS_CLI_HOST:-dcos-cli.demo.labs.stratio.com}' with user '${CLI_USER:-root}' and password '${CLI_PASSWORD:-stratio}'
        And I securely send requests to '${DCOS_IP}:443'
        When I send a 'POST' request to '/marathon/v2/apps' based on 'schemas/spark-history.json' as 'json' with:
            | $.container.docker.image    | UPDATE   | qa.stratio.com/stratio/spark-stratio-history-server:${STRATIO_SPARK_VERSION} | n/a    |
        Then the service response status must be '201'
        And in less than '300' seconds, checking each '20' seconds, the command output 'dcos task | grep -w history-server | wc -l' contains '1'
