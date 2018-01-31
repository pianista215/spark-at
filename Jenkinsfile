@Library('libpipelines@master') _

hose {
    EMAIL = 'qa'
    SLACKTEAM = 'stratioqa'
    MODULE = 'spark-at'
    BUILDTOOL = 'make'
    
    INSTALLSERVICES = [
            ['DCOSCLI':   ['image': 'stratio/dcos-cli:0.4.15',
                           'volumes': ['stratio/paasintegrationpem:0.1.0'],
                           'env':     ['DCOS_IP=10.200.0.156',
                                      'SSL=true',
                                      'SSH=true',
                                      'TOKEN_AUTHENTICATION=true',
                                      'DCOS_USER=admin@demo.stratio.com',
                                      'DCOS_PASSWORD=1234',
                                      'BOOTSTRAP_USER=operador',
                                      'PEM_FILE_PATH=/paascerts/PaasIntegration.pem'],
                           'sleep':  10]]
        ]

    INSTALLPARAMETERS = """
                    | -DDCOS_CLI_HOST=%%DCOSCLI#0
                    | -DDCOS_IP=10.200.0.156
                    | -DDCOS_USER=admin
                    | -DBOOTSTRAP_IP=10.200.0.155
                    | -DSPARK_DOCKER_IMAGE=qa.stratio.com/stratio/stratio-spark
		    | -DSTRATIO_SPARK_VERSION=2.3.0.0-SNAPSHOT
                    | """.stripMargin().stripIndent()



    INSTALL = { config ->
       if (config.INSTALLPARAMETERS.contains('GROUPS_SPARK')) {
            config.INSTALLPARAMETERS = "${config.INSTALLPARAMETERS}".replaceAll('-DGROUPS_SPARK', '-Dgroups')
	        doAT(conf: config)
        } else {
            doAT(conf: config, groups: ['BasicInstallation'])
        }

     }
}
