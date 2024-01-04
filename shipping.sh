script=$(realpath "$0")
script_path=$(dirname "$script")
source "$script_path"/common.sh
component=shipping
load_schema=mysql
func_java_setup