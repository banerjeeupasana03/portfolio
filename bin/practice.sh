#! /usr/bin/env bash
THIS_DIR="$(dirname "${BASH_SOURCE[0]}")"
ROOT_DIR="$(cd "$THIS_DIR/.." && pwd)"
# echo ">>> My family <<<"
# echo ">>> By Upasana Mukherjee <<<"
read_names() {
  local name_field
  local line
  local array_names=()
  local result  
  local input_file_path="$ROOT_DIR/tmp/input.txt"
  result="$(cat $input_file_path | while read -r line; do
    name_field="$(echo "$line" | cut -d',' -f1 | tr ' ' '_')"
    array_names+=("$name_field")
    echo "${array_names[@]}"
  done | tail -n 1)"
  echo "${result[@]}"
}

read_relations() {
  local relation_field
  local line
  local array_relations=()
  local result
  local input_file_path="$ROOT_DIR/tmp/input.txt"
  result="$(cat $input_file_path | while read -r line; do
    relation_field="$(echo "$line" | cut -d',' -f2)"
    array_relations+=("$relation_field")
    echo "${array_relations[@]}"
  done | tail -n 1)"
  echo "${result[@]}"
}

fn() {
   local name="$1"
   local relation="$2"
   echo "$name,$relation"
}

fn1() {
  local results_file_path="$ROOT_DIR/tmp/results.out"
  touch "$results_file_path"
  echo -n "" > "$results_file_path"
  local names=($(read_names))
  local relations=($(read_relations))
  local index
  local res
  # local array=()
  for index in "${!names[@]}"; do
    res="$(expr $index + 1),$(fn "${names[$index]}" "${relations[$index]}")"
    # array+=($res)
    echo "$res" >> "$results_file_path"
  done
  # echo "${array[@]}"
}

split_file() {
  local file="$ROOT_DIR/tmp/results.out"
  cat "$file" | grep -i 'mukherjee' > "$ROOT_DIR/tmp/result1.out"
  cat "$file" | grep -i 'banerjee' > "$ROOT_DIR/tmp/result2.out"
}

create_tmp_dir() {
  mkdir -p "$ROOT_DIR/tmp"
}

numbering() {
  local counter
  local result
  local line
  local file="$1"
  echo "$file"
  counter="0"
  echo ">>>>>ALWAYS PRINT RESULT1.OUT>>>>>>>"
  cat "$ROOT_DIR/tmp/result1.out"
  echo ">>>>>>>PRINT THE FILE I CALLED THE FUNCTION WITH>>>>>"
  cat "$ROOT_DIR/tmp/$file"
  echo ">>>>>>>>>>>>"
  cat "$ROOT_DIR/tmp/$file" | while read -r line; do
    counter="$(expr $counter + 1)"
    echo "$counter"
  done
}

main() {
  create_tmp_dir
  fn1
  split_file
  numbering "result1.out"
  numbering "result2.out"
}

# 1,Suman_Mukherjee,husband

# echo "$(expr 1 + 2)"
# # fn "Suman_Mukherjee" "husband"
# res="$(fn "Suman_Mukherjee" "husband")"
# echo "THIS IS A COMMAND SUBST RESULT : $res"
# a1=()
# a1+=( 'foo' )
# a1+=( 'bar' )
# a1+=( '1' )
# a1+=( '2' )
# echo "${a1[@]}"
# results=( '1,Suman_Mukherjee,husband' '2,Dipak_Mukherjee,father-in-law' )

[[ "${BASH_SOURCE[0]}" = "$0" ]] && main "$@"
