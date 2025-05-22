
import sys

class Logger:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

    @staticmethod
    def info(message):
        print(f"{Logger.OKBLUE}[INFO]{Logger.ENDC} {message}", file=sys.stderr)

    @staticmethod
    def success(message):
        print(f"{Logger.OKGREEN}[SUCCESS]{Logger.ENDC} {message}", file=sys.stderr)

    @staticmethod
    def warning(message):
        print(f"{Logger.WARNING}[WARNING]{Logger.ENDC} {message}", file=sys.stderr)

    @staticmethod
    def error(message):
        print(f"{Logger.FAIL}[ERROR]{Logger.ENDC} {message}", file=sys.stderr)

    @staticmethod
    def debug(message):
        # Optional: Add a flag to enable/disable debug logs
        print(f"{Logger.OKCYAN}[DEBUG]{Logger.ENDC} {message}", file=sys.stderr)
