"""Publishes a new FaturaX release to GitHub Releases and Shorebird.

1. Generate an Android release (APK) using Shorebird.
2. Create a release on GitHub with the APK attached.
3. Update the version in Firestore (version/v1).

Dependencies: pip install pyyaml ​​firebase-admin
Usage: python3 lib/scripts/storage_app.py
"""

import subprocess
import sys
from pathlib import Path

import firebase_admin
import yaml
from firebase_admin import credentials, firestore

PROJECT_ROOT = Path(__file__).resolve().parents[2]
PUBSPEC = PROJECT_ROOT / "pubspec.yaml"
APK_PATH = PROJECT_ROOT / "build/app/outputs/apk/release/app-release.apk"
SERVICE_ACCOUNT = PROJECT_ROOT / "lib/service-account.json"
FIREBASE_PROJECT_ID = "fatura-x-a7711"

def _run(cmd: list[str]) -> None:
    print(f"$ {' '.join(cmd)}")
    subprocess.run(cmd, cwd=PROJECT_ROOT, check=True)

def _main() -> None:
    version = str(yaml.safe_load(PUBSPEC.read_text())["version"])

    app = firebase_admin.initialize_app(
        credentials.Certificate(SERVICE_ACCOUNT),
        {"projectId": FIREBASE_PROJECT_ID},
    )

    _run(["shorebird", "release", "android", "--artifact", "apk"])
    print("\n")
    _run([
        "gh", "release", "create", f"v{version}", str(APK_PATH),
        "--title", f"Versão {version}",
    ])
    print("\n")

    db = firestore.client(app)
    db.collection("version").document("v1").update({"version": version})
    print(f"Versão {version} publicada.")

if __name__ == "__main__":
    try:
        _main()
    except subprocess.CalledProcessError as e:
        sys.exit(f"Comando falhou (código {e.returncode}): {' '.join(e.cmd)}")
