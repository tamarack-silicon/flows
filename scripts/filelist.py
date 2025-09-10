#!/usr/bin/python3

import sys
import pathlib
import argparse

def main():
    parser = argparse.ArgumentParser(
        prog='flist',
        description='Collect Verilog file list from .f file lists',
        epilog='bruh')
    parser.add_argument('-F', '--flist-rel-filelist', type=str, action='append', help='File list file contains list of Verilog to be parsed, any path is relative to the file list file')
    parser.add_argument('-f', '--flist-rel-pwd', type=str, action='append', help='File list file contains list of Verilog to be parsed, any path is relative to current working directory')

    args = parser.parse_args()

    for flist_path in args.flist_rel_filelist:
        flist_file = open(flist_path, 'r')
        path_of_flist = pathlib.Path(flist_path)
        for item in flist_file:
            if item.strip():
                print(str(path_of_flist.parent) + '/' + item, end='')

if __name__ == '__main__':
    main()
