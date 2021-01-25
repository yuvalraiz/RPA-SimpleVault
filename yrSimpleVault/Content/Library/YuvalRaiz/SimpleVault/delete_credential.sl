namespace: YuvalRaiz.SimpleVault
flow:
  name: delete_credential
  inputs:
    - section
    - label
  workflow:
    - sql_command:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: "${get_sp('YuvalRaiz.SimpleVault.db_hostname')}"
            - db_type: PostgreSQL
            - username: "${get_sp('YuvalRaiz.SimpleVault.db_username')}"
            - password:
                value: "${get_sp('YuvalRaiz.SimpleVault.db_password')}"
                sensitive: true
            - database_name: "${get_sp('YuvalRaiz.SimpleVault.db_name')}"
            - command: "${'''delete from  public.\"CredentialsStore\" where section = '%s' and label = '%s' ''' % (section, label )}"
            - trust_all_roots: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      sql_command:
        x: 200
        'y': 94
        navigate:
          afe3ce19-a7b1-92e5-7617-e81e0bba0906:
            targetId: 43e27bc0-d311-b555-dc09-90e448d5afa2
            port: SUCCESS
    results:
      SUCCESS:
        43e27bc0-d311-b555-dc09-90e448d5afa2:
          x: 447
          'y': 77
