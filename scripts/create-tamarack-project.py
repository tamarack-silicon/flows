#!/bin/python3

import sys
import os

def main() -> int:
    if(len(sys.argv) != 2):
        print('Usage: create-tamarack-project.py type project_dir')

    project_type = sys.argv[1]
    project_dir = sys.argv[2]
    if(os.path.exists(project_dir)):
        print(project_dir + ' already exists')
        return 1

    print('Enter RTL top-level module name: ', end='')
    rtl_top_name = input()

    print('Enter CSR block name: ', end='')
    csr_block_name = input()
    if not csr_block_name:
        print('No CSR block')
    
    print('Enter default testbench name: ', end='')
    tb_name = input()

    print('Enter UVM verification environment testbench top name: ', end='')
    verif_top_name = input()
    if not verif_top_name:
        print('No UVM verification environment')

    test = ''
    if verif_top_name:
        print('Enter UVM Default test name: ', end='')
        test = input()

    os.mkdir(project_dir)
    os.mkdir(project_dir + '/csr')
    os.mkdir(project_dir + '/doc')
    os.mkdir(project_dir + '/formal')
    os.mkdir(project_dir + '/ip')
    os.mkdir(project_dir + '/lint')
    os.mkdir(project_dir + '/rtl')
    os.mkdir(project_dir + '/syn')
    os.mkdir(project_dir + '/tb')
    os.mkdir(project_dir + '/verif')

    # CSR block
    if csr_block_name:
        with open(project_dir + '/csr/' + csr_block_name + '.rdl', 'w', encoding='utf-8') as csr_file:
            csr_file.write('addrmap ' + csr_block_name + ' {\n')
            csr_file.write('	name = "IP Block";\n');
            csr_file.write('	desc = "IP Block CSRs";\n\n')
            csr_file.write('	default regwidth = 32;\n')
            csr_file.write('	default sw = rw;\n')
            csr_file.write('	default hw = r;\n\n')
            csr_file.write('	reg output_data_r {\n')
            csr_file.write('		name = "Output Data Register";\n\n')
            csr_file.write('		field {\n')
            csr_file.write('			desc = "Output data";\n')
            csr_file.write('		} odata[31:0] = 0;\n\n')
            csr_file.write('	};\n\n')
            csr_file.write('	output_data_r output_data @ 0x0; \n')
            csr_file.write('};\n')

    # Lint Waiver
    with open(project_dir + '/lint/waiver.vlt', 'w', encoding='utf-8') as waiver_vlt:
        waiver_vlt.write('`verilator_config\n\n')
        waiver_vlt.write('lint_off -file "ip/*"\n')
            
    # RTL directory
    with open(project_dir + '/rtl/source.f', 'w', encoding='utf-8') as rtl_sourcef:
        if csr_block_name:
            rtl_sourcef.write(csr_block_name + '_pkg.sv\n')
            rtl_sourcef.write(csr_block_name + '.sv\n')
        rtl_sourcef.write(rtl_top_name + '.sv\n')

    with open(project_dir + '/rtl/' + rtl_top_name + '.sv', 'w', encoding='utf-8') as rtl_top_sv:
        rtl_top_sv.write('module ' + rtl_top_name + ';\n')
        rtl_top_sv.write('endmodule\n');

    # Testbench
    with open(project_dir + '/tb/' + tb_name + '.sv', 'w', encoding='utf-8') as tb_sv:
        tb_sv.write('module ' + tb_name + ';\n')
        tb_sv.write('endmodule\n');
        
    # UVM Verification directory
    if verif_top_name:
        with open(project_dir + '/verif/source.f', 'w', encoding='utf-8') as verif_sourcef:
            if csr_block_name:
                verif_sourcef.write(csr_block_name + '_ral_pkg.sv\n')
            verif_sourcef.write(verif_top_name + '.sv\n')
        
        with open(project_dir + '/verif/' + verif_top_name + '.sv', 'w', encoding='utf-8') as verif_top_sv:
            verif_top_sv.write('module ' + verif_top_name + ';\n')
            verif_top_sv.write('endmodule\n');

    with open(project_dir + '/Makefile', 'w', encoding='utf-8') as makefile_file:
        makefile_file.write('# RTL top level module name\n')
        makefile_file.write('RTL_TOP_NAME := ' + rtl_top_name + '\n\n')
        makefile_file.write('# CSR Block Name\n')
        makefile_file.write('CSR_BLOCK_NAME := ' + csr_block_name + '\n\n')
        makefile_file.write('# Design IP dependency in \'ip\' folder\n')
        makefile_file.write('RTL_IP_DEP := \n\n')
        makefile_file.write('# Design IP dependency in same folder as current ip\n')
        makefile_file.write('RTL_REPO_DEP := \n\n')
        makefile_file.write('# Verification IP dependency in \'ip\' folder\n')
        makefile_file.write('VERIF_IP_DEP := \n\n')
        makefile_file.write('# Verification IP dependency in same folder as current ip\n')
        makefile_file.write('VERIF_REPO_DEP := \n\n')
        makefile_file.write('# Default testbench name\n')
        makefile_file.write('TB_NAME := ' + tb_name + '\n\n')
        makefile_file.write('# Testbench top level module name\n')
        makefile_file.write('VERIF_TOP_NAME := ' + verif_top_name + '\n\n')
        makefile_file.write('# Default UVM test name\n')
        makefile_file.write('TEST := ' + test + '\n\n')
        makefile_file.write('include ip/flows/' + project_type + '.mk\n')
        
    return 0

if __name__ == '__main__':
    sys.exit(main())
