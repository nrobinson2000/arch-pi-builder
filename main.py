import pathlib
import requests
import hashlib


# Download and verify the latest Arch Linux ARM release
def download_release_archive(force=False):
    tarball = "ArchLinuxARM-rpi-aarch64-latest.tar.gz"

    # Ensure download path exists
    prefix = pathlib.Path('data/release')
    prefix.mkdir(parents=True, exist_ok=True)

    tarball_path = prefix.joinpath(tarball)

    # Avoid re-downloading
    if tarball_path.is_file() and not force:
        print(f"{tarball} already downloaded!")
        return

    base_url = "http://ca.us.mirror.archlinuxarm.org/os"

    # Create URLs
    release_url = f"{base_url}/{tarball}"
    md5sum_url = f"{release_url}.md5"

    # Download content
    release = requests.get(release_url).content
    md5sum = requests.get(md5sum_url).text.split()[0]

    # Verify checksum
    release_md5sum = hashlib.md5(release).hexdigest()

    if release_md5sum != md5sum:
        raise ValueError(f"{tarball} md5 check failed!")

    # Save file
    with open(tarball_path, 'wb') as f:
        f.write(release)


if __name__ == '__main__':
    download_release_archive()
