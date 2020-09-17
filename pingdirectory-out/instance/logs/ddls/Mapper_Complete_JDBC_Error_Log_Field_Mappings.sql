------------------------
--   
--   Log Field Mapping for cn=Complete JDBC Error Log Field Mappings,cn=Log Field Mappings,cn=config
--   AutoCreated by Directory Server
--   04/Sep/2020:17:50:02 +0000
--   
------------------------
CREATE TABLE error_log (
   time_stamp TIMESTAMP
,   product_name VARCHAR(18)
,   instance_name VARCHAR(100)
,   startup_id VARCHAR(15)
,   category VARCHAR(15)
,   severity VARCHAR(15)
,   message_id DECIMAL(21)
,   message VARCHAR(255)
)
--   
--   END
--   
