import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

from elements import Utils


class Watcher:
    done = False

    def __init__(self, directory):
        self.observer = Observer()
        self.directory_to_watch = directory

    def run(self):
        event_handler = Handler(self.observer)
        self.observer.schedule(event_handler, self.directory_to_watch, recursive=True)
        self.observer.daemon = True
        self.observer.start()
        try:
            while True and not Watcher.done:
                time.sleep(5)
        except Exception as e:
            self.observer.stop()
            print("Error on listener " + str(e))

        self.observer.stop()
        self.observer.join()

        alive = self.observer.is_alive()
        if alive:
            print("Observer is still Alive !")


class Handler(FileSystemEventHandler):
    created = False
    downloaded = False

    def __init__(self, observer):
        self.observer = observer

    def on_any_event(self, event, **kwargs):

        # Take action if file is directory (zip)
        if event.is_directory:
            pass

        # Take action here when a file is first created.
        elif event.event_type == 'created':
            Handler.created = True

        # Taken action here when a file is modified.
        elif event.event_type == 'modified':
            if ".tmp" not in event.src_path \
                    and "Unconfirmed" not in event.src_path \
                    and event.src_path not in Utils.installation_paths:

                Utils.installation_paths.append(event.src_path)
                print("File Downloaded - %s." % event.src_path)
                Handler.downloaded = True

