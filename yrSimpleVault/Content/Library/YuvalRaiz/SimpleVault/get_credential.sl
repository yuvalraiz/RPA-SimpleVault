namespace: YuvalRaiz.SimpleVault
flow:
  name: get_credential
  inputs:
    - section
    - label
  workflow:
    - sql_query:
        do:
          io.cloudslang.base.database.sql_query:
            - db_server_name: "${get_sp('YuvalRaiz.SimpleVault.db_hostname')}"
            - db_type: PostgreSQL
            - username: "${get_sp('YuvalRaiz.SimpleVault.db_username')}"
            - password:
                value: "${get_sp('YuvalRaiz.SimpleVault.db_password')}"
                sensitive: true
            - database_name: "${get_sp('YuvalRaiz.SimpleVault.db_name')}"
            - db_url: "${'''jdbc:postgresql://%s:5432/%s''' % (db_server_name,database_name)}"
            - command: "${'''select  username, passwd from public.\"CredentialsStore\" where section = '%s' and label = '%s';''' % (section, label)}"
            - trust_all_roots: 'true'
            - delimiter: '_|_'
            - key: label
        publish:
          - credentail: '${return_result}'
          - username: NA
          - passwd: '***'
        navigate:
          - HAS_MORE: decode_password
          - NO_MORE: CUSTOM
          - FAILURE: on_failure
    - decode_password:
        do:
          io.cloudslang.base.utils.base64_decoder:
            - data: "${credentail.split('_|_')[1]}"
            - username: "${credentail.split('_|_')[0]}"
        publish:
          - passwd:
              value: '${result}'
              sensitive: true
          - username
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - username
    - passwd
  results:
    - FAILURE
    - SUCCESS
    - CUSTOM
extensions:
  graph:
    steps:
      sql_query:
        x: 82
        'y': 151
        navigate:
          91a7ffbe-1a62-8414-1f92-ea0e353a4a93:
            targetId: b3918717-a31a-9244-d097-ecf70c408195
            port: NO_MORE
      decode_password:
        x: 493
        'y': 148
        navigate:
          f5bd33a6-3ccf-aa93-3f32-5c55ac8dd682:
            targetId: 43e27bc0-d311-b555-dc09-90e448d5afa2
            port: SUCCESS
    results:
      SUCCESS:
        43e27bc0-d311-b555-dc09-90e448d5afa2:
          x: 740
          'y': 146
      CUSTOM:
        b3918717-a31a-9244-d097-ecf70c408195:
          x: 349
          'y': 410
