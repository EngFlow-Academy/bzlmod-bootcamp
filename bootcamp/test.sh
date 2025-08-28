test_leaflet_exists() {
  local leaflet_path="$(rlocation rules_magic_leaflet/leaflet.txt)"

  if [[ -z "$leaflet_path" ]]; then
    echo "No leaflet_path specified."
    exit 1
  elif [[ ! -f "$leaflet_path" ]]; then
    echo "leaflet_path does not exist: ${leaflet_path}"
    exit 1
  fi

  printf 'Contents of "%s":\n---\n%s\n---\n' \
    "${leaflet_path}" "$(< ${leaflet_path})"
}
