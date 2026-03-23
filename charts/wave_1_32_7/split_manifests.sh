#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────────────
# split_manifests.sh
#
# Takes an already-interpolated Helm YAML file and splits it by kind:
#   - DELETE:   resources to discard (not written to any output file)
#   - ELEVATED: resources requiring higher privileges (for an admin)
#   - SELF:     everything else (resources you can apply yourself)
#
# Usage: ./split_manifests.sh <input_file> [output_dir]
# ──────────────────────────────────────────────────────────────────────

# ── Configuration ────────────────────────────────────────────────────
# Comma-delimited list of Kubernetes resource kinds per category.
# Kinds not listed in delete or elevated are routed to self.
delete_resources=""
elevated_resources="StorageClass,Namespace,ClusterRole,ClusterRoleBinding,PersistentVolume"

# ── Args ─────────────────────────────────────────────────────────────
INPUT_FILE="${1:-}"
OUTPUT_DIR="${2:-./rendered}"

if [[ -z "${INPUT_FILE}" ]]; then
    echo "Usage: $0 <input_file> [output_dir]" >&2
    exit 1
fi

if [[ ! -f "${INPUT_FILE}" ]]; then
    echo "ERROR: Input file not found: ${INPUT_FILE}" >&2
    exit 1
fi

ELEVATED_FILE="${OUTPUT_DIR}/elevated.yaml"
SELF_FILE="${OUTPUT_DIR}/self.yaml"

# ── Helper: check if a kind is in a comma-delimited list ─────────────
kind_in_list() {
    local kind="$1"
    local list="$2"
    [[ ",${list}," == *",${kind},"* ]]
}

# ── Step 1: Split into individual documents ──────────────────────────
mkdir -p "${OUTPUT_DIR}"

tmpdir=$(mktemp -d)
trap 'rm -rf "${tmpdir}"' EXIT

awk -v dir="${tmpdir}" '
    BEGIN { n = 0 }
    /^---/ { n++; next }
    { print >> (dir "/doc_" n ".yaml") }
' "${INPUT_FILE}"

# ── Step 2: Classify and route ───────────────────────────────────────
elevated_count=0
self_count=0
delete_count=0

: > "${ELEVATED_FILE}"
: > "${SELF_FILE}"

for doc in "${tmpdir}"/doc_*.yaml; do
    [[ -f "${doc}" ]] || continue

    kind=$(grep -m1 '^kind:' "${doc}" | awk '{print $2}' | tr -d '"' || true)

    if [[ -z "${kind}" ]]; then
        continue
    fi

    if kind_in_list "${kind}" "${delete_resources}"; then
        echo "  DELETE:   ${kind}"
        delete_count=$((delete_count + 1))

    elif kind_in_list "${kind}" "${elevated_resources}"; then
        echo "  ELEVATED: ${kind}"
        echo "---" >> "${ELEVATED_FILE}"
        cat "${doc}" >> "${ELEVATED_FILE}"
        elevated_count=$((elevated_count + 1))

    else
        echo "  SELF:     ${kind}"
        echo "---" >> "${SELF_FILE}"
        cat "${doc}" >> "${SELF_FILE}"
        self_count=$((self_count + 1))
    fi
done

# ── Summary ──────────────────────────────────────────────────────────
echo ""
echo "Done. Results in: ${OUTPUT_DIR}/"
echo "  Elevated (admin): ${elevated_count} resources -> $(basename "${ELEVATED_FILE}")"
echo "  Self-apply:       ${self_count} resources -> $(basename "${SELF_FILE}")"
echo "  Deleted:          ${delete_count} resources (discarded)"
