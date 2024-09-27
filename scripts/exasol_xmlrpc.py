import argparse
import ssl
import time
import logging
from xmlrpc.client import ServerProxy
from xmlrpc.client import Server as xmlrpc
import datetime

logging.basicConfig(
    filename="exasol_xmlrpc_polling.log",
    format="%(asctime)s %(name)s %(levelname)s %(message)s",
    filemode="a",
    level=logging.DEBUG,
)
logging.getLogger().addHandler(logging.StreamHandler())
logger = logging.getLogger("exasol_xmlrpc")

WAIT_DURATION: datetime.timedelta = datetime.timedelta(hours=1)
WAIT_SLEEP_TIME: datetime.timedelta = datetime.timedelta(seconds=15)


def has_started(server: ServerProxy) -> bool:
    started = True
    try:
        server.listMethods()
    except Exception as ex:
        logger.info(f"Server not yet started: {ex}")
        started = False
    return started


def wait(server: ServerProxy) -> None:
    start = datetime.datetime.now()

    def current_delta():
        return datetime.datetime.now() - start

    def remaining():
        return WAIT_DURATION - current_delta()

    while remaining().total_seconds() > 0:
        logger.info(
            f"Waiting for {WAIT_DURATION} (remaining: {remaining()}) with sleep time {WAIT_SLEEP_TIME}s"
        )

        if has_started(server):
            logger.info(f"Server started after {current_delta()}")
            return

        time.sleep(WAIT_SLEEP_TIME.seconds)

    if remaining().total_seconds() < 0:
        raise TimeoutError(
            f"Exasol management node could not be started after {current_delta()}!"
        )


def create_server(address, username, password) -> ServerProxy:
    url = f"https://{username}:{password}@{address}/cluster1"
    logger.info(f"Connecting to {username} @ {address}")
    return xmlrpc(url, context=ssl._create_unverified_context())


def check_db_started(server: ServerProxy):
    logger.info("Checking if 'exadb' database is running")
    if not server.db_exadb.runningDatabase():
        raise RuntimeError("Exasol database is not started!")


def run():
    parser = argparse.ArgumentParser(description="Exasol XMLRPC Interactions")
    parser.add_argument("--license-server-address", type=str, required=True)
    parser.add_argument("--username", type=str, required=True)
    parser.add_argument("--password", type=str, required=True)

    args = parser.parse_args()
    logger.info("The following arguments are provided: '%s'" % args)

    try:
        server = create_server(
            args.license_server_address, args.username, args.password
        )
        wait(server)
        check_db_started(server)
    except Exception as ex:
        logger.info('Exception "%s" was thrown!' % str(ex))
        return 1


if __name__ == "__main__":
    exit(run())
