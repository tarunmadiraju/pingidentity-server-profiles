------------------------
--   
--   Log Field Mapping for cn=Complete JDBC Access Log Field Mappings,cn=Log Field Mappings,cn=config
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
,   intermediate_client_request VARCHAR(50)
,   result_code DECIMAL(10)
,   additional_information VARCHAR(30)
,   matched_dn VARCHAR(255)
,   referral_urls VARCHAR(255)
,   processing_time DOUBLE PRECISION
,   intermediate_client_result VARCHAR(255)
,   target_host VARCHAR(50)
,   target_port DECIMAL(6)
,   source_address VARCHAR(30)
,   target_address VARCHAR(30)
,   target_protocol VARCHAR(15)
,   protocol_name VARCHAR(15)
,   disconnect_reason VARCHAR(30)
,   message VARCHAR(60)
,   message_id_to_abandon DECIMAL(21)
,   entry_dn VARCHAR(255)
,   alternate_authorization_dn VARCHAR(30)
,   protocol_version VARCHAR(15)
,   bind_dn VARCHAR(255)
,   authentication_type VARCHAR(30)
,   sasl_mechanism_name VARCHAR(30)
,   authenticated_user_dn VARCHAR(255)
,   authentication_failure_id DECIMAL(21)
,   authentication_failure_reason VARCHAR(30)
,   target_attribute VARCHAR(30)
,   request_oid VARCHAR(30)
,   response_oid VARCHAR(30)
,   new_rdn VARCHAR(30)
,   delete_old_rdn VARCHAR(1)
,   new_superior_dn VARCHAR(255)
,   base_dn VARCHAR(255)
,   scope DECIMAL(21)
,   filter VARCHAR(30)
,   requested_attributes VARCHAR(255)
,   entries_returned DECIMAL(21)
,   unindexed VARCHAR(1)
,   request_controls VARCHAR(30)
,   response_controls VARCHAR(30)
)
--   
--   END
--   
