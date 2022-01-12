CREATE TABLE `<Project ID>.<Dataset name>.gcs_events` ( -- ReceivedMessage. See https://cloud.google.com/pubsub/docs/reference/rpc/google.pubsub.v1#receivedmessage
  message STRUCT <   -- ReceivedMessage/PubsubMessage. See https://cloud.google.com/pubsub/docs/reference/rest/v1/PubsubMessage
    context STRUCT < -- See https://airflow.apache.org/docs/apache-airflow/stable/macros-ref.html
      ts TIMESTAMP OPTIONS(description = "bq-datetime"),
      dag_tags ARRAY < STRING >,
      task_instance_key_str STRING,
      ti_dag_id STRING,
      run_id STRING,
      task_project_id STRING >,
    publishTime TIMESTAMP OPTIONS(description = "bq-datetime"), -- PubsubMessage
    messageId INT64, -- ReceivedMessage/PubsubMessage
    orderingKey STRING, -- ReceivedMessage/PubsubMessage
    attributes STRUCT < -- ReceivedMessage/PubsubMessage/GCS Notification format. See https://cloud.google.com/storage/docs/pubsub-notifications#format
      payloadFormat STRING,
      objectGeneration INT64,
      overwrittenByGeneration INT64,
      overwroteGeneration INT64,
      bucketId STRING,
      notificationConfig STRING,
      eventType STRING,
      eventTime TIMESTAMP OPTIONS(description = "bq-datetime"),
      objectId STRING,
      pubsub STRING >,
    data STRUCT < -- ReceivedMessage/PubsubMessage/GCS Object format. See https://cloud.google.com/storage/docs/json_api/v1/objects#resource-representations
      etag STRING,
      crc32c STRING,
      mediaLink STRING,
      metadata ARRAY <
        STRUCT < 
          key STRING, 
          value STRING >>,      
      owner STRUCT <
        entity STRING,
        entityId STRING >,
      size INT64,
      kind STRING,
      storageClass STRING,
      timeCreated TIMESTAMP OPTIONS(description = "bq-datetime"),
      timeDeleted TIMESTAMP OPTIONS(description = "bq-datetime"),
      name STRING,
      contentType STRING,
      contentEncoding STRING,
      contentDisposition STRING,
      cacheControl STRING,
      contentLanguage STRING,
      generation INT64,
      bucket STRING,
      md5Hash STRING,
      metageneration INT64,
      componentCount INT64,
      id STRING,
      updated TIMESTAMP OPTIONS(description = "bq-datetime"),
      retentionExpirationTime TIMESTAMP OPTIONS(description = "bq-datetime"),
      eventBasedHold BOOL,
      temporaryHold BOOL,
      customTime STRING,
      timeStorageClassUpdated TIMESTAMP OPTIONS(description = "bq-datetime"),      
      customerEncryption STRUCT <
        encryptionAlgorithm STRING,
        keySha256 STRING >,
      kmsKeyName STRING,
      acl ARRAY <
        STRUCT < 
          kind STRING,
          id STRING,
          selfLink STRING,
          bucket STRING,
          object STRING,
          generation INT64,
          entity STRING,
          role STRING,
          email STRING,
          entityId STRING,
          domain STRING,
          projectTeam STRUCT <
            projectNumber STRING,
            team STRING >,
          etag STRING >>,
      selfLink STRING >>,
  gcs_event_ts TIMESTAMP OPTIONS(description = "bq-datetime"),  
  deliveryAttempt INT64, -- ReceivedMessage
  ackId STRING -- ReceivedMessage
);
