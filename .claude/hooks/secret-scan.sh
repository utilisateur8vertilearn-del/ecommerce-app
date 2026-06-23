#!/usr/bin/env bash
# Bloque un `git commit` si un secret est détecté dans les fichiers indexés.
set -euo pipefail
payload="$(cat)"
cmd="$(printf '%s' "$payload" | grep -o '"command"[^,]*' | head -1 || true)"
if ! printf '%s' "$cmd" | grep -qi 'git commit'; then exit 0; fi
patterns='(password|passwd|secret|api[_-]?key|token|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|connectionstring|aws_secret_access_key)'
hits="$(git diff --cached -U0 2>/dev/null | grep -iE "^\+.*$patterns" || true)"
if [ -n "$hits" ]; then
  echo "⛔ COMMIT BLOQUÉ : secret potentiel détecté." >&2
  printf '%s\n' "$hits" | head -5 >&2
  exit 2
fi
exit 0