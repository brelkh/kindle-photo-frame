#!/usr/bin/env python3
# coding: utf-8

from pathlib import Path
import requests
import logging

from gphotos.authorize import Authorize
from gphotos.restclient import RestClient

PHOTOS_DIR = Path("/mnt/us/photos")
ALBUM_TITLE = "kindle"

logging.basicConfig(level=logging.WARNING)
log = logging.getLogger(__name__)

class KindleGPhotosUpdater:
    def setup(self):
        credentials_file = Path(".gphotos.token")
        secret_file = Path("client_secret.json")

        scope = [
            "https://www.googleapis.com/auth/photoslibrary.readonly",
            "https://www.googleapis.com/auth/photoslibrary.sharing",
        ]

        api_url = "https://photoslibrary.googleapis.com/$discovery/rest?version=v1"

        self.auth = Authorize(scope, credentials_file, secret_file, 3)
        self.auth.authorize()
        self.client = RestClient(api_url, self.auth.session)

    def get_album_id(self):
        albums = self.client.sharedAlbums.list.execute(pageSize=50).json()
        for album in albums.get("sharedAlbums", []):
            if album.get("title") == ALBUM_TITLE:
                return album["id"]
        return None

    def existing_filenames(self):
        return {p.name for p in PHOTOS_DIR.iterdir() if p.is_file()}

    def run(self):
        self.setup()
        album_id = self.get_album_id()
        if not album_id:
            print("Album not found:", ALBUM_TITLE)
            return 1

        existing = self.existing_filenames()

        body = {
            "albumId": album_id,
            "pageSize": 100,
        }

        next_page = None
        downloaded = 0

        while True:
            if next_page:
                body["pageToken"] = next_page

            res = self.client.mediaItems.search.execute(body).json()

            for item in res.get("mediaItems", []):
                filename = item.get("filename")
                mime = item.get("mimeType", "")

                if not filename or not mime.startswith("image/"):
                    continue

                if filename in existing:
                    continue

                url = item["baseUrl"] + "=w2048-h2048"
                dest = PHOTOS_DIR / filename

                print("Downloading:", filename)
                r = requests.get(url, timeout=30)
                r.raise_for_status()
                dest.write_bytes(r.content)

                downloaded += 1
                existing.add(filename)

            next_page = res.get("nextPageToken")
            if not next_page:
                break

        print(f"Downloaded {downloaded} new photos")
        return 0


if __name__ == "__main__":
    raise SystemExit(KindleGPhotosUpdater().run())
