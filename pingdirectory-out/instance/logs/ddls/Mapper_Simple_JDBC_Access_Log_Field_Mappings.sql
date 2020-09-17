------------------------
--   
--   Log Field Mapping for cn=Simple JDBC Access Log Field Mappings,cn=Log Field Mappings,cn=config
--   AutoCreated by Directory Server
--   04/Sep/2020:17:50:02 +0000
--   
------------------------
CREATE TABLE access_log (
   time_stamp TIMESTAMP
,   startup_id VARCHAR(15)
,   message_type VARCHAR(15)
,   product_name VARCHAR(18)
,   instance_name VARCHAR(100)
,   connection_id DECIMAL(21)
,   operation_type VARCHAR(15)
,   operation_id DECIMAL(21)
,   message_id DECIMAL(21)
,   origin VARCHAR(30)
,   requester_dn VARCHAR(255)
,   requester_ip_address VARCHAR(50)
,   result_code DECIMAL(10)
,   processing_time DOUBLE PRECISION
,   disconnect_reason VARCHAR(30)
,   message VARCHAR(60)
,   entry_dn VARCHAR(255)
,   bind_dn VARCHAR(255)
,   authentication_type VARCHAR(30)
,   sasl_mechanism_name VARCHAR(30)
,   authenticated_user_dn VARCHAR(255)
,   target_attribute VARCHAR(30)
,   response_oid VARCHAR(30)
,   new_rdn VARCHAR(30)
,   delete_old_rdn VARCHAR(1)
,   new_superior_dn VARCHAR(255)
,   base_dn VARCHAR(255)
,   search_scope DECIMAL(21)
,   filter VARCHAR(30)
)
--   
--   END
--   
