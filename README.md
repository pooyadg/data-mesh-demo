# Confluent Data Mesh Demo

A Data Mesh prototype built on [Confluent Cloud](https://www.confluent.io/confluent-cloud/tryfree/).

![Preview](preview.png)

## Hosted Version

The Data Mesh demo is available in a hosted environment by visiting:

https://www.confluent-data-mesh-prototype.com

The hosted version of the demo allows you to see a subset of the full demo functionality without 
requiring you to run any code locally. When you would like to run a full version of the demo, follow the 
[Running Locally](#running-locally) instructions below.

A companion blog post can be found here:

*TODO Blog Link*

## Running Locally 

###  Prerequisties
* [Confluent Cloud](https://www.confluent.io/confluent-cloud/tryfree/) account
  * New Confluent Cloud signups receive _$400_ to spend within Confluent Cloud during their first 60 days.
    Use Confluent Cloud promo code `DATAMESH200` to receive an additional **$200** free usage
    This will sufficiently cover one day of running this example, beyond which you may be billed 
    for the Confluent Cloud resources until you destroy them. Enter the promo code in the Billing & payment page
    under the Payment details subsection.

* [Confluent Cloud CLI](https://docs.confluent.io/ccloud-cli/current/install.html) `v1.36.0` or later
* Java 11
* Gradle
* Node
* Yarn
* [jq](https://stedolan.github.io/jq/download/)

### Instructions

* Clone the repository and change into the project directory
  ```
  git clone https://github.com/confluentinc/data-mesh-demo
  cd data-mesh-demo
  ```

* Ensure your `ccloud` CLI is logged into Confluent Cloud (the ``--save`` argument saves your Confluent Cloud 
  user login credentials or refresh token (in the case of SSO) to the local ``netrc`` file, preventing timeouts)
  ```
  ccloud login --save
  ```
  
* If you want to create a new Data Mesh on Confluent Cloud as well as build and run the demo, this command 
  creates Confluent Cloud resources, including an environment, Apache Kafka cluster,
  [ksqlDB](https://ksqldb.io/) Application, and sample Data Products
  <br/><br/>
  **Note**: The script waits for all cloud resources to be fully provisioned and *can take 15+ minutes* to complete. 
  In addition, the command needs to be run from a new terminal (not one that has run this command previously).

  ```
  make data-mesh
  ```

  Once the above command is complete, a configuration file for your new data mesh environment will be located in 
  the `stack-configs` folder local to this project. The file path will resemble 
  `stack-configs/java-service-account-1234567.config`. This file contains important security and configuration 
  data for your new data mesh environment. You should protect this file and retain it as you'll need it later 
  to destroy the new data mesh environment.

 
* If you previously ran the `make data-mesh` command and still have the Confluent Cloud environemnt and 
configuration file, you can skip the previous data mesh creation step and just run the demo with:
  ```
  CONFIG_FILE=<path-to-config-file> make run
  ```
 
* Once the data mesh creation and demo run process is complete, you will see the Spring Boot banner 
  and log entries that look similar to: 
  ```
  ...
    .   ____          _            __ _ _
   /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
  ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
   \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
    '  |____| .__|_| |_|_| |_\__, | / / / /
   =========|_|==============|___/=/_/_/_/
  ...
  2021-10-23 14:02:31.473  INFO 27995 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
  ...
  2021-10-23 14:02:31.475  INFO 27995 --- [           main] o.s.m.s.b.SimpleBrokerMessageHandler     : Started.
  2021-10-23 14:02:31.489  INFO 27995 --- [           main] io.confluent.demo.datamesh.DataMeshDemo  : Started DataMeshDemo in 2.337 seconds (JVM running for 2.651)
  Log ....
  ```
 
* To view the data mesh demo, open a web browser to: http://localhost:8080

### Teardown

Once you are done with the Data Mesh demo you'll want to stop the server and destroy the cloud resources.

* Stop the demo web service by issuing `<ctrl-c>` in the terminal where you started it.

* Destroy the Data Mesh resources in Confluent Cloud (including the environment, cluster, and ksqlDB app).
 
  (_Note_: This command expects the path to the configuration file created during the `make data-mesh` 
  command to be present in the `CONFIG_FILE` environment variable. If you started a new terminal you may need to 
  set the value to the appropriate file):
  ```
  make destroy
  ```
  
### Data Mesh Demo API Usage

The Data Mesh Demo models a data mesh via a REST API. The following are examples of some functions you can perform
with the REST API directly. By default, the REST API listens on http://localhost:8080

* Discover the existing data products:
  ```sh
  curl -s localhost:8080/priv/data-products | jq
  ```
  ```json
  [
    {
      "@type": "DataProduct",
      "name": "users",
      "qualifiedName": "lsrc-dnxzz:.:users-value:1",
      "description": "All users from all regions (both national and international)",
      "owner": "@membership-team",
      "domain": "membership",
      "sla": "tier-1",
      "quality": "authoritative",
      "urls": {
        "schemaUrl": "https://confluent.cloud/environments/env-op2xo/schema-registry/schemas/users-value",
        "portUrl": "https://confluent.cloud/environments/env-op2xo/clusters/lkc-5joyz/topics/users",
        "lineageUrl": "https://confluent.cloud/environments/env-op2xo/clusters/lkc-5joyz/stream-lineage/stream/topic-users/n/topic-users/overview",
        "exportUrl": "https://confluent.cloud/environments/env-op2xo/clusters/lkc-5joyz/connectors/browse"
      },
      "schema": {
        "subject": "users-value",
        "version": 1,
        "id": 100003,
        "schema": "{\"type\":\"record\",\"name\":\"users\",\"namespace\":\"ksql\",\"fields\":[{\"name\":\"registertime\",\"type\":\"long\"},{\"name\":\"userid\",\"type\":\"string\"},{\"name\":\"regionid\",\"type\":\"string\"},{\"name\":\"gender\",\"type\":\"string\"}],\"connect.name\":\"ksql.users\"}"
      }
    },
    ...
  ]
  ```

* Get one specifc data product. This requires the qualified name of the data product:

  ```sh
  curl -s localhost:8080/data-products/lsrc-w8v85:.:users-value:1 | jq
  ```
  ```json
  {
    "@type": "DataProduct",
    "name": "users",
    "qualifiedName": "lsrc-dnxzz:.:users-value:1",
    "description": "All users from all regions (both national and international)",
    "owner": "@membership-team",
    "domain": "membership",
    "sla": "tier-1",
    "quality": "authoritative",
    "urls": {
      "schemaUrl": "https://confluent.cloud/environments/env-op2xo/schema-registry/schemas/users-value",
      "portUrl": "https://confluent.cloud/environments/env-op2xo/clusters/lkc-5joyz/topics/users",
      "lineageUrl": "https://confluent.cloud/environments/env-op2xo/clusters/lkc-5joyz/stream-lineage/stream/topic-users/n/topic-users/overview",
      "exportUrl": "https://confluent.cloud/environments/env-op2xo/clusters/lkc-5joyz/connectors/browse"
    },
    "schema": {
      "subject": "users-value",
      "version": 1,
      "id": 100003,
      "schema": "{\"type\":\"record\",\"name\":\"users\",\"namespace\":\"ksql\",\"fields\":[{\"name\":\"registertime\",\"type\":\"long\"},{\"name\":\"userid\",\"type\":\"string\"},{\"name\":\"regionid\",\"type\":\"string\"},{\"name\":\"gender\",\"type\":\"string\"}],\"connect.name\":\"ksql.users\"}"
    }
  }
  ```

* Get all the data products and topics in one list:
  ```sh
  curl -s localhost:8080/priv/data-products/manage | jq
  ```
  ```json
  [
    {
      "@type": "DataProduct",
      "name": "users",
      "qualifiedName": "lsrc-dnxzz:.:users-value:1",
      "description": "All users from all regions (both national and international)",
      "owner": "@membership-team",
      "domain": "membership",
      "sla": "tier-1",
      "quality": "authoritative",
      "urls": {
        "schemaUrl": "https://confluent.cloud/environments/env-op2xo/schema-registry/schemas/users-value",
        "portUrl": "https://confluent.cloud/environments/env-op2xo/clusters/lkc-5joyz/topics/users",
        "lineageUrl": "https://confluent.cloud/environments/env-op2xo/clusters/lkc-5joyz/stream-lineage/stream/topic-users/n/topic-users/overview",
        "exportUrl": "https://confluent.cloud/environments/env-op2xo/clusters/lkc-5joyz/connectors/browse"
      },
      "schema": {
        "subject": "users-value",
        "version": 1,
        "id": 100003,
        "schema": "{\"type\":\"record\",\"name\":\"users\",\"namespace\":\"ksql\",\"fields\":[{\"name\":\"registertime\",\"type\":\"long\"},{\"name\":\"userid\",\"type\":\"string\"},{\"name\":\"regionid\",\"type\":\"string\"},{\"name\":\"gender\",\"type\":\"string\"}],\"connect.name\":\"ksql.users\"}"
      }
    },
    {
      "@type": "Topic",
      "name": "trending_stocks",
      "qualifiedName": "lsrc-dnxzz:.:trending_stocks-value:2"
    },
    ...
  ]
  ```

## Client Development Instructions

The client is built with [Elm](https://elm-lang.org/) and the source is build as part of the Java server build step. 
If you would like to develop the client code independently, you can use the following.

To run a webserver hosting the client code that will watch for changes and load
connected browsers:
```sh
cd client
yarn
yarn dev
```

The website is now served at http://localhost:9000.
