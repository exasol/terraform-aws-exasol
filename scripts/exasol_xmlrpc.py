import argparse
import ssl
import time
from xmlrpclib import Fault
from xmlrpclib import Server as xmlrpc

WAIT_MAX_ITERATIONS = 12
WAIT_INITIAL_SLEEP_TIME = 60 * 5 # every 5 minutes, total 12 * 5 = 1h wait

CLUSTER_URL = 'https://{}:{}@{}/cluster1'
BUCKETFS_PORTS = {'http_port': 2580, 'https_port': 2581}

def edit_bucket_fs(server):
    server.bfsdefault.editBucketFS(BUCKETFS_PORTS)

def create_buckets(server, args):
    for bucket in args.buckets:
        try:
            print "Creating bucket '%s'" % bucket
            server.bfsdefault.addBucket({
                'bucket_name': bucket,
                'public_bucket': True,
                'read_password': args.password,
                'write_password': args.password
            })
        except Fault as ex:
            if 'Given bucket ID is already in use' in str(ex):
                continue
            else:
                raise ex

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
        print "Waiting iteration count: %s" % max_iterations

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
    print "Checking if 'exadb' database is running"
    if not server.db_exadb.runningDatabase():
        raise Exception("Exasol database is not started!")

def run():
    parser = argparse.ArgumentParser(description='Exasol XMLRPC Interactions')
    parser.add_argument('--license-server-address', type=str, required=True)
    parser.add_argument('--username', type=str, required=True)
    parser.add_argument('--password', type=str, required=True)
    parser.add_argument('--buckets', type=str, nargs='*')

    args = parser.parse_args()
    print "The following arguments are provided: '%s'" % args

    try:
        server = create_server(args.license_server_address, args.username, args.password)
        wait(server)
        check_db_started(server)
        edit_bucket_fs(server)
        if args.buckets:
            create_buckets(server, args)
    except Exception as ex:
        print 'Exception "%s" was thrown!' % str(ex)
        return 1

if __name__ == "__main__":
    exit(run())
