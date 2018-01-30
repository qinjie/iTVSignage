import logging

def get_logger(name='main', reset_handlers=True, log_file=None, log_console=True, log_level=logging.INFO):
    logger = logging.getLogger(name)

    logger.setLevel(log_level)
    log_formatter = logging.Formatter("%(asctime)s [%(threadName)-12.12s] [%(levelname)-5.5s]  %(message)s")

    # Clear handler if required
    if logger.handlers and reset_handlers:
        logger.handlers = []

    if log_file:
        fileHandler = logging.FileHandler("{0}/{1}.txt".format(os.getcwd(), log_file))
        fileHandler.setFormatter(log_formatter)
        logger.addHandler(fileHandler)

    if log_console:
        consoleHandler = logging.StreamHandler()
        consoleHandler.setFormatter(log_formatter)
        logger.addHandler(consoleHandler)

    return logger
