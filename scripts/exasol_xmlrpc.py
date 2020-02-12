import argparse
import ssl
import time
from xmlrpc.client import Fault
from xmlrpc.client import Server as xmlrpc

WAIT_MAX_ITERATIONS = 12
WAIT_INITIAL_SLEEP_TIME = 60 * 5 # every 5 minutes, total 12 * 5 = 1h wait

CLUSTER_URL = 'https://{}:{}@{}/cluster1'

def has_started(server):
    started = True
    try:
        server.listMethods()
    except:
        started = False
    return started

def wait(server):
    sleep_time = WAIT_INITIAL_SLEEP_TIME
    max_iterations = WAIT_MAX_ITERATIONS

    while max_iterations > 0:
        print("Waiting iteration count: %s" % max_iterations)

        started = has_started(server)
        if started:
            break

        max_iterations -= 1
        time.sleep(sleep_time)

    if max_iterations == 0:
        raise Exception("Exasol management node could not be started after long time!")

def create_server(address, username, password):
    url = CLUSTER_URL.format(username, password, address)
    server = xmlrpc(url, context=ssl._create_unverified_context())
    return server

def check_db_started(server):
    print("Checking if 'exadb' database is running")
    if not server.db_exadb.runningDatabase():
        raise Exception("Exasol database is not started!")

def run():
    parser = argparse.ArgumentParser(description='Exasol XMLRPC Interactions')
    parser.add_argument('--license-server-address', type=str, required=True)
    parser.add_argument('--username', type=str, required=True)
    parser.add_argument('--password', type=str, required=True)

    args = parser.parse_args()
    print("The following arguments are provided: '%s'" % args)

    try:
        server = create_server(args.license_server_address, args.username, args.password)
        wait(server)
        check_db_started(server)
    except Exception as ex:
        print('Exception "%s" was thrown!' % str(ex))
        return 1

if __name__ == "__main__":
    exit(run())
