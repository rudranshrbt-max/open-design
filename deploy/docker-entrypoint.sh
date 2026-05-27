#!/bin/sh
set -e

if [ -n "$PORT" ] && [ -z "$OD_PORT" ]; then
  export OD_PORT="$PORT"
fi

if [ -n "$RENDER_EXTERNAL_URL" ]; then
  if [ -z "$OD_ALLOWED_ORIGINS" ]; then
    export OD_ALLOWED_ORIGINS="$RENDER_EXTERNAL_URL"
  else
    case ",$OD_ALLOWED_ORIGINS," in
      *",$RENDER_EXTERNAL_URL,"*) ;;
      *)
        export OD_ALLOWED_ORIGINS="$OD_ALLOWED_ORIGINS,$RENDER_EXTERNAL_URL"
        ;;
    esac
  fi
fi

echo "[entrypoint] OD_PORT=${OD_PORT:-7456}"
echo "[entrypoint] OD_BIND_HOST=${OD_BIND_HOST:-0.0.0.0}"
echo "[entrypoint] OD_ALLOWED_ORIGINS=${OD_ALLOWED_ORIGINS:-<none>}"

if [ "${OD_BIND_HOST:-127.0.0.1}" != "127.0.0.1" ] && \
   [ "${OD_BIND_HOST:-127.0.0.1}" != "localhost" ] && \
   [ "${OD_BIND_HOST:-127.0.0.1}" != "::1" ] && \
   [ -z "$OD_API_TOKEN" ]; then
  echo "[entrypoint] FATAL: OD_BIND_HOST requires OD_API_TOKEN" >&2
  exit 1
fi

echo "[entrypoint] exec node /app/apps/daemon/dist/cli.js "$@"
exec node /app/apps/daemon/dist/cli.js "$@"
