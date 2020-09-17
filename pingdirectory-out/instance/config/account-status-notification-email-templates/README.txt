This directory contains a set of template files that may be used to generate
multi-part email messages for sending to end users and/or server administrators
whenever certain events occur that affect the state of a user account. A
separate template will be used for each type of event so that the message
contents, recipients, and other details may be customized for that event.



THE MESSAGE TEMPLATE FILE FORMAT

A message template file must begin with a header section that specifies the
recipient and sender addresses, the message subject, and the values of any
custom headers that should appear in the message. It also indicates whether the
template should be enabled and used to send email messages. This header section
must begin with the line "----- BEGIN HEADERS -----", and it may contain a
number of name-value pairs that provide information about the message. Each
name-value pair should appear on a separate line, and the name and value must
be separated by a colon and optional spaces. The elements that may appear in
the header section include:

     ENABLED -- Specifies whether this template is enabled and should be used
          to generate an email message. This element must be present and must
          have a value of either "true" or "false". This is primarily intended
          for cases in which a message should only be generated under certain
          circumstances. If you do not ever want a message sent for a
          particular notification type, you should not specify a template file
          for that notification type in the configuration for the multi-part
          email account status notification handler.

     TO -- Specifies a primary recipient for the email message, which will be
          visible to all recipients. The value may be either an email address
          by itself (e.g., "jdoe@example.com") or a name followed by the email
          address in angle brackets (e.g., "John Doe <jdoe@example.com>"). This
          element may be provided multiple times to specify multiple TO
          recipients. It may also be omitted if the message should have only CC
          and/or BCC recipients, but the message must have at least one TO, CC,
          or BCC recipient.

     CC -- Specifies a carbon-copied recipient for the email message, which
          will be visible to all recipients. The value may be either an email
          address by itself (e.g., "jdoe@example.com") or a name followed by
          the email address in angle brackets (e.g.,
          "John Doe <jdoe@example.com>"). This element may be provided multiple
          times to specify multiple CC recipients. It may also be omitted if
          the message should have only TO and/or BCC recipients, but the
          message must have at least one TO, CC, or BCC recipient.

     BCC -- Specifies a blind carbon-copied recipient for the email message,
          which will not be visible to other recipients. The value may be
          either an email address by itself (e.g., "jdoe@example.com") or a
          name followed by the email address in angle brackets (e.g.,
          "John Doe <jdoe@example.com>"). This element may be provided multiple
          times to specify multiple BCC recipients. It may also be omitted if
          the message should have only TO and/or CC recipients, but the message
          must have at least one TO, CC, or BCC recipient.

     FROM -- Specifies the address from which the email message should appear
          to be sent. The value may be either an email address by itself (e.g.,
          "jdoe@example.com") or a name followed by the email address in angle
          brackets (e.g., "John Doe <jdoe@example.com>"). This element must be
          provided exactly once.

     REPLY-TO -- Specifies the default address to which replies should be sent.
          The value may be either an email address by itself (e.g.,
          "jdoe@example.com") or a name followed by the email address in angle
          brackets (e.g., "John Doe <jdoe@example.com>"). This element is
          optional and may be provided at most once.

     SUBJECT -- Specifies the subject for the email message. This element must
          be provided exactly once.

     HEADER -- Defines a custom header that should be included in the email
          message. The header value should itself be a name-value pair with the
          name and value separated by a colon and optional spaces (e.g.,
          "X-Custom-Header-Name:Custom Header Value"). This is an optional
          element that may be provided multiple times to specify multiple
          headers with the same or different names.


The header section must be followed by either or both a plain-text and
HTML-formatted body sections. Each of these sections consists of free-form text
that may span multiple lines and will continue until the beginning of the next
section or the end of the template file is reached. If a plain-text body is to
be included, then it must start with the line
"----- BEGIN PLAIN-TEXT BODY -----". If an HTML-formatted body is to be
included, then it must start with the line "----- BEGIN HTML BODY -----". At
least one of these sections must be included, but if you are including an
HTML-formatted body, then it is recommended that you also include a plain-text
body for the benefit of clients that prefer plain text or can't handle HTML
content. Any blank line at the beginning or end of the body text will be
removed, but blank lines in the middle of the body will be preserved.

The template may also contain any number of attachment sections, which describe
attachments that should be in the message. Each attachment section must start
with the line "----- BEGIN ATTACHMENT -----", and may include the following
elements (using the same colon-delimited syntax as used in the header section):

     FILENAME -- The name (without any path information) of the file to be
          attached. This must be provided, and the file must exist in the same
          directory as the template file.

     CONTENT-TYPE -- The MIME type for the attachment. This is an optional
          element, and if it is not provided, then a default content-type of
          "application/octet-stream" will be used.

     INLINE -- Indicates whether it should be an inline attachment (e.g., an
          image that should be referenced within the HTML body, in which case
          the image source path should be "cid:" followed by the filename, like
          "cid:company-logo.png"). If present, its value must be either "true"
          or "false". If it is omitted, a default value of "false" will be
          assumed.



CUSTOMIZING THE MESSAGE CONTENT

Before the server parses the template file to generate the message, it will
pre-process the file with the Apache Velocity templating engine
(https://velocity.apache.org/). This makes it possible to customize the content
of the message with information from the account status notification, details
from the associated user entry, and other information.

The following variables will be defined in the context, many of which are
intended for use with custom directives:

     $account_entry -- The entry for the user with which the account status
          notification is associated.

     $notification_type -- The name of the notification type for the account
          status notification.

     $notification_message -- A human-readable message that provides a basic
          description of the account status notification.

     $before_entry -- A version of the associated entry as it appeared before
          the operation was processed. This will only be available for
          notifications generated as a result of modify or modify DN operations.

     $after_entry -- A version of the associated entry as it appeared after the
          operation was processed. This will only be available for notifications
          generated as a result of modify or modify DN operations.


In addition to the built-in directives that Velocity offers, the following
custom directives are also available for use:

     #getEntryDN(entry, variableName) -- Retrieves a string representation of
          the DN of the provided entry and stores it in the specified Velocity
          context variable.

     #getHasAttribute(entry, attributeName, variableName) -- Determines whether
          the provided entry includes the specified attribute. If so, a value
          of "true" will be stored in the specified Velocity context variable;
          if not, a value of "false" will be stored.

     #getUserAttributeNames(entry, variableName) -- Retrieves a list of the
          names of the user attributes contained in the provided entry and
          stores that list in the specified Velocity context variable.

     #getOperationalAttributeNames(entry, variableName) -- Retrieves a list of
          the names of the operational attributes contained in the provided
          entry and stores that list in the specified Velocity context
          variable.

     #getAttributeValue(entry, attributeName, variableName) -- Retrieves the
          first value for the indicated attribute from the provided entry and
          stores it in the specified Velocity context variable. If the
          attribute is not present in the entry, then the variable will be
          removed from the context.

     #getAttributeValues(entry, attributeName, variableName) -- Retrieves the
          list of values for the indicated attribute from the provided entry
          and stores that list in the specified Velocity context variable. If
          the attribute is not present in the entry, then an empty list will be
          stored.

     #getEntryMatchesLDAPFilter(entry, filterString, variableName) --
          Determines whether the provided entry matches the LDAP filter with
          the given string representation. If it does match, a value of "true"
          will be stored in the Velocity context variable; otherwise, a value
          of "false" will be stored.

     #getJSONObjectValue(entry, attributeName, variableName) -- Retrieves the
          first value for the indicated attribute that can be parsed as a JSON
          object and stores that object in the specified variable in the
          Velocity context. If the attribute does not exist in the provided
          entry, or if none of its values can be parsed as a JSON object, then
          the variable will be removed from the context.

     #getJSONObjectValues(entry, attributeName, variableName) -- Retrieves a
          list of all values for the indicated attribute that can be parsed as
          JSON objects and stores that list in the specified variable in the
          Velocity context. If the attribute does not exist in the provided
          entry, or if none of its values can be parsed as a JSON object, then
          an empty list will be stored.

     #getJSONFieldValue(jsonObject, fieldName, variableName) -- Retrieves the
          first value for the indicated field from the provided JSON object and
          stores its string representation in the specified Velocity context
          variable. Nested fields may be targeted by using the period as a
          delimiter between field names (e.g., "name.first" targets the "first"
          field inside a JSON object that is a value for the outer "name"
          field). If the field does not exist in the provided object, then the
          variable will be removed from the context.

     #getJSONFieldValues(jsonObject, fieldName, variableName) -- Retrieves all
          values for the indicated field from the provided JSON object and
          stores a list of their string representations in the specified
          Velocity context variable. Nested fields may be targeted by using the
          period as a delimiter between field names (e.g., "name.first" targets
          the "first" field inside a JSON object that is a value for the outer
          "name" field). If the field does not exist in the provided object (or
          if its value is an empty array), then an empty list will be stored.

     #getJSONObjectMatchesFilter(jsonObject, jsonObjectFilterString,
          variableName) -- Determines whether the provided JSON object matches
          the JSON object filter with the given string representation. If it
          does match, a value of "true" will be stored in the specified
          Velocity context variable; otherwise, a value of "false" will be
          stored.

     #getEntry(entryDN, variableName) -- Retrieves the entry with the provided
          DN from the server and stores it in the specified Velocity context
          variable. If the entry does not exist, then the variable will be
          removed from the context.

     #searchForEntries(baseDN, scopeString, filterString, variableName) --
          Performs an internal search with the provided base DN, scope (which
          must be one of "base", "one", "sub", or "subordinates"), and filter,
          and stores the list of matching entries in the specified variable in
          the context. If the search does not match any entries, if it matches
          more than 20 entries, or if the search criteria is not indexed, then
          an empty list will be stored.

     #getParentDN(entryDN, variableName) -- Determines the parent DN for the
          provided entry DN and stores it in the specified Velocity context
          variable. If the provided DN contains only a single component, then
          an empty string will be stored. If the provided DN is the null DN
          (and therefore does not have a parent), then the variable will be
          removed from the context.

     #getIsAttributeModified(beforeEntry, afterEntry, attributeName,
          variableName) -- Determines whether the indicated attribute has been
          modified between the provided before and after representations of the
          entry. If so, then a value of "true" will be stored in the specified
          Velocity context variable; otherwise, a value of "false" will be
          stored.

     #getIsAnyAttributeModified(beforeEntry, afterEntry, attributeName1,
          attributeName2, ..., variableName) -- Determines whether at least one
          of the listed attributes has been modified between the provided
          before and after representations of the entry. If so, then a value of
          "true" will be stored in the specified Velocity context variable;
          otherwise, a value of "false" will be stored. The first two arguments
          to this directive must be the before and after representations of the
          target entry, and the last argument must be the name of the variable
          in which to store the result. All arguments in between will be
          treated as the names or OIDs of the attributes for which to make the
          determination. At least one attribute name or OID must be provided.

     #getModifiedAttributeNames(beforeEntry, afterEntry, variableName) --
          Determines which attributes have been modified between the provided
          before and after representations of the entry and stores a list of
          their names in the specified Velocity context variable. If the
          provided entries are identical, then an empty list will be stored.

     #getModifiedAttributeAddedValues(beforeEntry, afterEntry, attributeName,
          variableName) -- Retrieves a list of the values for the indicated
          attribute that have been added between the provided before and after
          representations of an entry and stores that list in the specified
          Velocity context variable. If the attribute was not altered, or if
          values were only removed from it, then an empty list will be stored.

     #getModifiedAttributeRemovedValues(beforeEntry, afterEntry, attributeName,
          variableName) -- Retrieves a list of the values for the indicated
          attribute that have been removed between the provided before and
          after representations of an entry and stores that list in the
          specified Velocity context variable. If the attribute was not
          altered, or if values were only added to it, then an empty list will
          be stored.

     #getOperationMatchesConnectionCriteria(criteriaDN, variableName) --
          Determines whether the operation that triggered the notification
          matches the connection criteria defined in the entry with the given
          DN. If it does match, a value of "true" will be stored in the
          specified Velocity context variable; otherwise, a value of "false"
          will be stored.

     #getOperationMatchesRequestCriteria(criteriaDN, variableName) --
          Determines whether the operation that triggered the notification
          matches the request criteria defined in the entry with the given DN.
          If it does match, a value of "true" will be stored in the specified
          Velocity context variable; otherwise, a value of "false" will be
          stored.

     #getNotificationPropertyNames(variableName) -- Retrieves a list of the
          names of the account status notification properties that are defined
          for the notification and stores that list in the specified Velocity
          context variable.

     #getNotificationPropertyValue(propertyName, variableName) -- Retrieves the
          first value for the given account status notification property and
          stores it in the specified Velocity context variable. If the property
          is not defined, then the variable will be removed from the context.

     #getNotificationPropertyValues(propertyName, variableName) -- Retrieves
          the list of values for the given account status notification property
          and stores that list in the specified Velocity context variable. If
          the property is not defined, then an empty list will be stored.

     #getFormattedTimestamp(timestamp, formatString, variableName) -- Retrieves
          a representation of the provided timestamp (which must be in
          generalized time form) formatted with the given format string (which
          must be compatible with the java.text.SimpleDateFormat class) and
          stores it in the specified Velocity context variable. The JVM's
          default time zone will be used.

     #getFormattedTimestamp(timestamp, formatString, timeZone, variableName) --
          Retrieves a representation of the provided timestamp (which must be
          in generalized time form) formatted with the given format string
          (which must be compatible with the java.text.SimpleDateFormat class)
          in the indicated time zone (which must be compatible with the
          java.time.ZoneId class) and stores it in the specified Velocity
          context variable.

     #getFileExistsInTemplateDirectory(fileName, variableName) -- Determines
          whether a file exists with the given name (which must not contain
          path information) in the same directory as the template. If so, a
          value of "true" will be stored in the specified Velocity context
          variable; otherwise, a value of "false" will be stored.


The following account status notification properties are available for use in
conjunction with the #getNotificationPropertyValue and
#getNotificationPropertyValues directives:

     notification-type -- The name of the account status notification type.

     notification-time -- A generalized time representation of the time that
          the notification was generated.

     account-dn -- The DN of the entry for the associated user account.

     password-policy-dn -- The DN of the password policy that governs the
          associated user account.

     password-changed-time -- A generalized time representation of the time the
          user's password was last changed.

     seconds-since-password-change -- The number of seconds since the account's
          password was last changed.

     time-since-password-change -- A human-readable duration indicating the
          length of time since the user's password was last changed.

     account-is-usable -- A value of "true" if the account is considered
          usable, or "false" if it is not (e.g., if the account is
          locked/expired/not yet active, if the password is expired, if the
          user must choose a new password, etc.).

     account-usability-errors -- A list of human-readable strings providing
          information about any errors that currently affect the account's
          usability.

     account-usability-warnings -- A list of human-readable strings providing
          information about any warning conditions that have the potential to
          affect the account's usability in the near future.

     account-usability-notices -- A list of human-readable strings providing
          information about any notable account state conditions that are not
          expected to affect the account's usability in the near future.

     account-is-disabled -- The value "true" if the account has been
          administratively disabled, or "false" if not.

     account-is-not-yet-active -- The value "true" if the account has an
          activation time in the future, or "false" if not.

     account-activation-time -- A generalized time representation of the
          account activation time, if defined.

     seconds-until-account-activation -- The number of seconds until the
          account becomes active, if it has an activation time that is in the
          future.

     time-until-account-activation -- A human-readable duration indicating the
          length of time until the account becomes active, if it has an
          activation time that is in the future.

     seconds-since-account-activation -- The number of seconds since the
          account became active, if it has an activation time that is in the
          past.

     time-since-account-activation -- A human-readable duration indicating the
          length of time since the account became active, if it has an
          activation time that is in the past.

     account-is-expired -- The value "true" if the account has an expiration
          time in the past, or "false" if not.

     account-expiration-time -- A generalized time representation of the
          account expiration time, if defined.

     seconds-until-account-expiration -- The number of seconds until the
          account expires, if it has an expiration time in the future.

     time-until-account-expiration -- A human-readable duration indicating the
          length of time until the account expires, if it has an expiration
          time in the future.

     seconds-since-account-expiration -- The number of seconds since the
          account expired, if it has an expiration time in the past.

     time-since-account-expiration -- A human-readable duration indicating the
          length of time since the account expired, if it has an expiration
          time in the past.

     account-is-failure-locked -- The value "true" if the account has been
          temporarily or permanently locked as a result of too many failed
          authentication attempts, or "false" if not.

     failure-locked-time -- A generalized time representation of the time that
          the account became failure-locked, if applicable.

     account-unlock-time -- A generalized time representation of the time that
          the account will be automatically unlocked, if it is temporarily
          locked as a result of too many failed authentication attempts.

     seconds-until-unlock -- The number of seconds until the account unlock
          time arrives, if applicable.

     time-until-unlock -- A human-readable duration indicating the length of
          time until the account unlock time arrives, if applicable.

     failure-lockout-count -- The number of failed authentication attempts
          required to lock an account, if configured.

     failure-lockout-duration-seconds -- The number of seconds that a
          failure-locked account will be prevented from authenticating, if
          defined.

     failure-lockout-duration -- A human-readable duration that indicates how
          long a failure-locked account will be prevented from authenticating,
          if defined.

     account-is-idle-locked -- The value "true" if the account is locked
          because it has been too long since the user last authenticated, or
          "false" if not.

     idle-lockout-interval-seconds -- The maximum number of seconds that may
          pass between successful authentications before an account becomes
          idle-locked, if configured.

     idle-lockout-interval -- A human-readable duration that indicates how much
          time may pass between successful authentications before an account
          becomes idle-locked, if configured.

     last-login-time -- A generalized time representation of the time that the
          user last successfully authenticated, if available.

     seconds-since-last-login -- The number of seconds that have passed since
          the user last successfully authenticated, if available.

     time-since-last-login -- A human-readable duration indicating the length
          of time that has passed since the user last successfully
          authenticated, if available.

     last-login-ip-address -- The IP address of the client from which the user
          last authenticated, if available.

     account-is-reset-locked -- The value "true" if the account is locked
          because the user failed to choose a new password in a timely manner
          after an administrative password reset, or "false" if not.

     maximum-password-reset-age-seconds -- The maximum number of seconds that a
          user has to choose a new password after an administrative password
          reset before the account becomes reset-locked, if defined.

     maximum-password-reset-age -- A human-readable duration indicating the
          maximum length of time that a user has to choose a new password after
          an administrative password reset before the account becomes
          reset-locked, if defined.

     must-change-password -- The value "true" if the user will be required to
          choose a new password before they will be allowed to perform any
          other operations in the server, or "false" if not.

     account-was-unlocked -- The value "true" if the account had been locked
          but was just unlocked by the associated operation, or "false" if not.

     password-is-expired -- The value "true" if the account has an expired
          password, or "false" if not.

     password-is-expiring -- The value "true" if the account has a password
          that will expire in the near future (as determined by the
          password-expiration-warning-interval property in the associated
          password policy), or "false" if not.

     maximum-password-age-seconds -- The maximum number of seconds that an
          account is permitted to keep the same password before it expires, if
          defined.

     maximum-password-age -- A human-readable duration indicating the maximum
          length of time that an account is permitted to keep the same password
          before it expires, if defined.

     password-expiration-time -- A generalized time representation of the time
          that the account's password did/will expire, if applicable.

     seconds-until-password-expiration -- The number of seconds until the
          account's password will expire, if it has an expiration time that is
          in the future.

     time-until-password-expiration -- A human-readable duration indicating the
          length of time until the account's password will expire, if it has an
          expiration time that is in the future.

     seconds-since-password-expiration -- The number of seconds since the
          account's password expired, if it has an expiration time that is in
          the past.

     time-since-password-expiration -- A human-readable duration indicating the
          length of time since the account's password expired, if it has an
          expiration time that is in the past.

     old-password -- The clear-text password that the account had before the
          associated operation was processed, if available.

     new-password -- The clear-text password that the account has after the
          associated operation was processed, if available.

     new-generated-password -- The clear-text password that was generated for
          the account by the associated operation, if applicable.

     requester-ip-address -- The IP address of the client that requested the
          associated operation, if available.

     requester-dn -- The DN of the account that requested the associated
          operation.

     operation-type -- The name of the operation type for the associated
          operation.

     operation-id -- A string representation of the operation ID for the
          associated operation.

     connection-id -- A string representation of the connection ID for the
          associated operation.

     server-uuid -- A string representation of the unique identifier generated
          for the server instance that processed the associated operation.

     instance-name -- The instance name for the server instance that processed
          the associated operation.



ACCOUNT STATUS NOTIFICATION TYPES

The available account status notification types include:

     account-temporarily-locked -- A user's account has been temporarily locked
          as a result of too many failed authentication attempts. The account
          will remain locked until a configured length of time elapses, or
          until the password is reset by an administrator.

     account-permanently-locked -- A user's account has been permanently
          locked as a result of too many failed authentication attempts. The
          account will remain locked until the password is reset by an
          administrator.

     account-idle-locked -- An authentication attempt failed because it has
          been too long (longer than the idle-lockout-interval configured in
          the associated password policy) since the user last successfully
          authenticated to the server. The account will remain locked until the
          password is reset by an administrator.

     account-reset-locked -- An authentication attempt failed because the
          user's account was in a "must change password" state following an
          administrative password reset, but the user did not choose a new
          password in a timely manner (within the max-password-reset-age
          duration configured in the associated password policy). The account
          will remain locked until the password is reset again by an
          administrator.

     account-unlocked -- A locked user account has been unlocked (e.g., by an
          administrative password reset).

     account-disabled -- A user's account has been administratively disabled
          (by setting the ds-pwp-account-disabled operational attribute to true
          in the user entry). The user will not be allowed to authenticate
          until this attribute is removed or its value is set to false.

     account-enabled -- A user's account has been administratively enabled (by
          setting the ds-pwp-account-disabled operational attribute to false in
          the user entry, or by removing that attribute from the entry).

     account-not-yet-active -- An authentication attempt failed because the
          user account is configured with an activation time (via the
          ds-pwp-account-activation-time operational attribute in the user's
          entry) that is in the future. The user will not be allowed to
          authenticate until this time arrives, until the activation time is
          removed, or until the activation time is set to a time in the past.

     account-expired -- An authentication attempt failed because the user
          account is configured with an expiration time (via the
          ds-pwp-account-expiration-time operational attribute in the user's
          entry) that is in the past. The user will not be allowed to
          authenticate until the expiration time is removed or set to a time in
          the future.

     password-expired -- An authentication attempt failed because the user's
          password has expired. The user will not be allowed to authenticate
          until their password is reset by an administrator (or until they
          change their own password if allow-expired-password-changes is set to
          true in the associated password policy).

     password-expiring -- The user successfully authenticated, but their
          password will expire in the near future (as determined by the
          password-expiration-warning-interval setting in the associated
          password policy). This notification type will only be generated the
          first time that a user authenticated within a given warning interval.

     password-reset -- A user's password has been reset by an administrator.

     password-changed -- A user changed their own password.

     account-created -- A new account was created in an add request that
          matches the criteria specified in the
          account-creation-notification-request-criteria property of the
          account status notification handler configuration.

     account-updated -- An existing account was updated in a modify or modify
          DN request that matches the criteria specified in the
          account-update-notification-request-criteria property of the account
          status notification handler configuration.
