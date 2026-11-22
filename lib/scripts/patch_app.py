"""Publishes a Shorebird patch (Dart code only) for an existing FaturaX release.

Does not create a new release, does not touch GitHub Releases or Firestore.
Users receive the patch through ShorebirdUpdater (lib/services/update_app.dart)
and it takes effect on the next app restart.

The app calls checkForUpdate() without a track, so it only sees the "stable"
track. Patches on "staging"/"beta" are not delivered to regular users.

Only use for Dart changes. Native changes (android/, Gradle, Kotlin, plugins
with native code, permissions) require a full release via storage_app.py.

Usage:
    python3 lib/scripts/patch_app.py                          # latest release, stable
    python3 lib/scripts/patch_app.py 1.0.28+1                 # specific release, stable
    python3 lib/scripts/patch_app.py --track staging          # latest release, staging
"""

import argparse
import subprocess
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[2]

def _run(cmd: list[str]) -> None:
    print(f"$ {' '.join(cmd)}")
    subprocess.run(cmd, cwd=PROJECT_ROOT, check=True)

def _main() -> None:
    parser = argparse.ArgumentParser(description="Publica um patch Shorebird (somente Dart).")
    parser.add_argument("release_version", nargs="?", default="latest",
                        help="Release a ser corrigida (padrão: latest)")
    parser.add_argument("--track", default="stable",
                        help="Track do patch: stable, beta, staging ou customizada (padrão: stable)")
    args = parser.parse_args()

    _run([
        "shorebird", "patch", "android",
        f"--release-version={args.release_version}",
        f"--track={args.track}",
    ])
    print(f"\nPatch publicado para a release {args.release_version} (track {args.track}).")

if __name__ == "__main__":
    try:
        _main()
    except subprocess.CalledProcessError as e:
        sys.exit(f"Comando falhou (código {e.returncode}): {' '.join(e.cmd)}")
