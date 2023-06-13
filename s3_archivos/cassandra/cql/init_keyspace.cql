CREATE KEYSPACE IF NOT EXISTS sensorKeyspace
  WITH REPLICATION = {
   'class' : 'SimpleStrategy',
   'replication_factor' : 1
  };
