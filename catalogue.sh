
script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh

func_setup_nodejs catalogue


systemctl restart catalogue