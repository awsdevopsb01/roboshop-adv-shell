script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
component=catalogue
load_schema="mongo"

func_setup_nodejs

