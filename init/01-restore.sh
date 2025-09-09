#!/usr/bin/env bash
set -euo pipefail

echo "[init] Restauración inicial de Postgres (si aplica)"

# El entrypoint de Postgres arranca un servidor temporal y ejecuta todo lo de
# /docker-entrypoint-initdb.d *solo* cuando el data dir está vacío.
# Aquí aprovechamos para restaurar.

: "${POSTGRES_DB:?POSTGRES_DB no definido}"
: "${POSTGRES_USER:?POSTGRES_USER no definido}"

BACKUP_PATH="${BACKUP_FILE:-}"

if [[ -z "${BACKUP_PATH}" ]]; then
  echo "[init] BACKUP_FILE no definido. No se restaurará nada."
  exit 0
fi

if [[ ! -f "${BACKUP_PATH}" ]]; then
  echo "[init] Archivo ${BACKUP_PATH} no existe. Saltando restauración."
  exit 0
fi

echo "[init] Usando backup: ${BACKUP_PATH}"
export PGPASSWORD="${POSTGRES_PASSWORD:-}"

# El entrypoint ya tiene el server “listo para psql/pg_restore” vía socket local.
case "${BACKUP_PATH}" in
  *.sql)
    echo "[init] Detectado .sql -> psql -f"
    psql -v ON_ERROR_STOP=1 -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -f "${BACKUP_PATH}"
    ;;
  *.sql.gz)
    echo "[init] Detectado .sql.gz -> gunzip | psql"
    gunzip -c "${BACKUP_PATH}" | psql -v ON_ERROR_STOP=1 -U "${POSTGRES_USER}" -d "${POSTGRES_DB}"
    ;;
  *.dump|*.tar|*.backup)
    echo "[init] Detectado formato pg_restore -> pg_restore"
    # --no-owner evita problemas de ownership; --clean re-crea objetos si existen
    pg_restore --no-owner --role="${POSTGRES_USER}" --clean --if-exists \
      -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" "${BACKUP_PATH}"
    ;;
  *)
    echo "[init] Extensión no reconocida. Usa .sql, .sql.gz, .dump, .tar o .backup"
    exit 1
    ;;
esac

echo "[init] Restauración completada."
