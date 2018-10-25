#!/usr/bin/python
# -*- coding: utf-8 -*-
# Copyright: (c) 2018, Ansible Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import absolute_import, division, print_function
__metaclass__ = type

DOCUMENTATION = '''
---
module: proxysql_proxysql_servers
version_added: "2.5"
author: "Timo Runge (@timorunge)"
short_description: Adds or removes proxysql hosts from proxysql admin interface.
description:
   - The M(proxysql_proxysql_servers) module adds or removes proxysql hosts using
     the proxysql admin interface.
options:
  hostname:
    description:
      - The ip address at which the proxysql instance can be contacted.
    required: True
  port:
    description:
      - The port at which the proxysql instance can be contacted.
    default: 6032
  weight:
    description:
      - Currently unused, but in the roadmap for future enhancements.
        The bigger the weight of a server relative to other weights, the higher
        the probability of the server being chosen from the hostgroup. If
        omitted the proxysql database default for I(weight) is 0.
  comment:
    description:
      - Text field that can be used for any purposed defined by the user.
        Could be a description of what the host stores, a reminder of when the
        host was added or disabled, or a JSON processed by some checker script.
    default: ''
  state:
    description:
      - When C(present) - adds the host, when C(absent) - removes the host.
    choices: [ "present", "absent" ]
    default: present
extends_documentation_fragment:
  - proxysql.managing_config
  - proxysql.connectivity
'''

EXAMPLES = '''
---
# This example adds a server, it saves the proxysql server config to disk, but
# avoids loading the proxysql server config to runtime (this might be because
# several servers are being added and the user wants to push the config to
# runtime in a single batch using the M(proxysql_manage_config) module). It
# uses supplied credentials to connect to the proxysql admin interface.

- proxysql_proxysql_servers:
    login_user: 'admin'
    login_password: 'admin'
    hostname: 'mysql01'
    state: present
    load_to_runtime: False

# This example removes a server, saves the proxysql server config to disk, and
# dynamically loads the proxysql server config to runtime. It uses credentials
# in a supplied config file to connect to the proxysql admin interface.

- proxysql_proxysql_servers:
    config_file: '~/proxysql.cnf'
    hostname: 'mysql02'
    state: absent
'''

RETURN = '''
stdout:
    description: The proxysql host modified or removed from proxysql
    returned: On create/update will return the newly modified host, on delete
              it will return the deleted record.
    type: dict
    "sample": {
        "changed": true,
        "hostname": "192.168.52.1",
        "msg": "Added server to proxysql_servers",
        "server": {
            "comment": "",
            "hostname": "192.168.52.1",
            "port": "6032",
            "weight": "1"
        },
        "state": "present"
    }
'''

ANSIBLE_METADATA = {'metadata_version': '1.1',
                    'status': ['stableinterface'],
                    'supported_by': 'community'}


from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils.mysql import mysql_connect
from ansible.module_utils.six import iteritems
from ansible.module_utils._text import to_native

try:
    import MySQLdb
    import MySQLdb.cursors
except ImportError:
    MYSQLDB_FOUND = False
else:
    MYSQLDB_FOUND = True

# ===========================================
# proxysql module specific support methods.
#


def perform_checks(module):
    if module.params["login_port"] < 0 \
       or module.params["login_port"] > 65535:
        module.fail_json(
            msg="login_port must be a valid unix port number (0-65535)"
        )

    if module.params["port"] < 0 \
       or module.params["port"] > 65535:
        module.fail_json(
            msg="port must be a valid unix port number (0-65535)"
        )

    if not MYSQLDB_FOUND:
        module.fail_json(
            msg="the python mysqldb module is required"
        )


def save_config_to_disk(cursor):
    cursor.execute("SAVE PROXYSQL SERVERS TO DISK")
    return True


def load_config_to_runtime(cursor):
    cursor.execute("LOAD PROXYSQL SERVERS TO RUNTIME")
    return True


class ProxySQLServer(object):

    def __init__(self, module):
        self.state = module.params["state"]
        self.save_to_disk = module.params["save_to_disk"]
        self.load_to_runtime = module.params["load_to_runtime"]

        self.hostname = module.params["hostname"]
        self.port = module.params["port"]

        config_data_keys = ["hostname",
                            "port",
                            "weight",
                            "comment"]

        self.config_data = dict((k, module.params[k])
                                for k in config_data_keys)

    def check_server_config_exists(self, cursor):
        query_string = \
            """SELECT count(*) AS `host_count`
               FROM proxysql_servers
               WHERE hostname = %s
                 AND port = %s"""

        query_data = \
            [self.hostname,
             self.port]

        cursor.execute(query_string, query_data)
        check_count = cursor.fetchone()
        return (int(check_count['host_count']) > 0)

    def check_server_config(self, cursor):
        query_string = \
            """SELECT count(*) AS `host_count`
               FROM proxysql_servers
               WHERE hostname = %s
                 AND port = %s"""

        query_data = \
            [self.hostname,
             self.port]

        for col, val in iteritems(self.config_data):
            if val is not None:
                query_data.append(val)
                query_string += "\n  AND " + col + " = %s"

        cursor.execute(query_string, query_data)
        check_count = cursor.fetchone()
        return (int(check_count['host_count']) > 0)

    def get_server_config(self, cursor):
        query_string = \
            """SELECT *
               FROM proxysql_servers
               WHERE hostname = %s
                 AND port = %s"""

        query_data = \
            [self.hostname,
             self.port]

        cursor.execute(query_string, query_data)
        server = cursor.fetchone()
        return server

    def create_server_config(self, cursor):
        query_string = \
            """INSERT INTO proxysql_servers (
               hostname,
               port"""

        cols = 2
        query_data = \
            [self.hostname,
             self.port]

        for col, val in iteritems(self.config_data):
            if val is not None:
                cols += 1
                query_data.append(val)
                query_string += ",\n" + col

        query_string += \
            (")\n" +
             "VALUES (" +
             "%s ," * cols)

        query_string = query_string[:-2]
        query_string += ")"

        cursor.execute(query_string, query_data)
        return True

    def update_server_config(self, cursor):
        query_string = """UPDATE proxysql_servers"""

        cols = 0
        query_data = []

        for col, val in iteritems(self.config_data):
            if val is not None:
                cols += 1
                query_data.append(val)
                if cols == 1:
                    query_string += "\nSET " + col + "= %s,"
                else:
                    query_string += "\n    " + col + " = %s,"

        query_string = query_string[:-1]
        query_string += ("\nWHERE hostname = %s" +
                         "\n  AND port = %s")

        query_data.append(self.hostname)
        query_data.append(self.port)

        cursor.execute(query_string, query_data)
        return True

    def delete_server_config(self, cursor):
        query_string = \
            """DELETE FROM proxysql_servers
               WHERE hostname = %s
                 AND port = %s"""

        query_data = \
            [self.hostname,
             self.port]

        cursor.execute(query_string, query_data)
        return True

    def manage_config(self, cursor, state):
        if state:
            if self.save_to_disk:
                save_config_to_disk(cursor)
            if self.load_to_runtime:
                load_config_to_runtime(cursor)

    def create_server(self, check_mode, result, cursor):
        if not check_mode:
            result['changed'] = \
                self.create_server_config(cursor)
            result['msg'] = "Added server to proxysql_servers"
            result['server'] = \
                self.get_server_config(cursor)
            self.manage_config(cursor,
                               result['changed'])
        else:
            result['changed'] = True
            result['msg'] = ("Server would have been added to" +
                             " proxysql_servers, however check_mode" +
                             " is enabled.")

    def update_server(self, check_mode, result, cursor):
        if not check_mode:
            result['changed'] = \
                self.update_server_config(cursor)
            result['msg'] = "Updated server in proxysql_servers"
            result['server'] = \
                self.get_server_config(cursor)
            self.manage_config(cursor,
                               result['changed'])
        else:
            result['changed'] = True
            result['msg'] = ("Server would have been updated in" +
                             " proxysql_servers, however check_mode" +
                             " is enabled.")

    def delete_server(self, check_mode, result, cursor):
        if not check_mode:
            result['server'] = \
                self.get_server_config(cursor)
            result['changed'] = \
                self.delete_server_config(cursor)
            result['msg'] = "Deleted server from proxysql_servers"
            self.manage_config(cursor,
                               result['changed'])
        else:
            result['changed'] = True
            result['msg'] = ("Server would have been deleted from" +
                             " proxysql_servers, however check_mode is" +
                             " enabled.")

# ===========================================
# Module execution.
#


def main():
    module = AnsibleModule(
        argument_spec=dict(
            login_user=dict(default=None, type='str'),
            login_password=dict(default=None, no_log=True, type='str'),
            login_host=dict(default='127.0.0.1'),
            login_unix_socket=dict(default=None),
            login_port=dict(default=6032, type='int'),
            config_file=dict(default='', type='path'),
            hostname=dict(required=True, type='str'),
            port=dict(default=6032, type='int'),
            weight=dict(default=0, type='int'),
            comment=dict(default='', type='str'),
            state=dict(default='present', choices=['present',
                                                   'absent']),
            save_to_disk=dict(default=True, type='bool'),
            load_to_runtime=dict(default=True, type='bool')
        ),
        supports_check_mode=True
    )

    perform_checks(module)

    login_user = module.params["login_user"]
    login_password = module.params["login_password"]
    config_file = module.params["config_file"]

    cursor = None
    try:
        cursor = mysql_connect(module,
                               login_user,
                               login_password,
                               config_file,
                               cursor_class=MySQLdb.cursors.DictCursor)
    except MySQLdb.Error as e:
        module.fail_json(
            msg="unable to connect to ProxySQL Admin Module.. %s" % to_native(e)
        )

    proxysql_server = ProxySQLServer(module)
    result = {}

    result['state'] = proxysql_server.state
    if proxysql_server.hostname:
        result['hostname'] = proxysql_server.hostname

    if proxysql_server.state == "present":
        try:
            if not proxysql_server.check_server_config(cursor):
                if not proxysql_server.check_server_config_exists(cursor):
                    proxysql_server.create_server(module.check_mode,
                                                  result,
                                                  cursor)
                else:
                    proxysql_server.update_server(module.check_mode,
                                                  result,
                                                  cursor)
            else:
                result['changed'] = False
                result['msg'] = ("The server already exists in proxysql_servers" +
                                 " and doesn't need to be updated.")
                result['server'] = \
                    proxysql_server.get_server_config(cursor)
        except MySQLdb.Error as e:
            module.fail_json(
                msg="unable to modify server.. %s" % to_native(e)
            )

    elif proxysql_server.state == "absent":
        try:
            if proxysql_server.check_server_config_exists(cursor):
                proxysql_server.delete_server(module.check_mode,
                                              result,
                                              cursor)
            else:
                result['changed'] = False
                result['msg'] = ("The server is already absent from the" +
                                 " proxysql_servers memory configuration")
        except MySQLdb.Error as e:
            module.fail_json(
                msg="unable to remove server.. %s" % to_native(e)
            )

    module.exit_json(**result)

if __name__ == '__main__':
    main()
