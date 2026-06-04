#!/bin/python3

import sys
import os
import subprocess

def create_verification_ip(project_dir):
	print('Enter VIP package name(for example tamarack_gpio_agent_pkg): ', end='')
	package_name = input()

	print('Enter UVM verification environment testbench top name(for example ' + project_dir + '_tests_top): ', end='')
	verif_top_name = input()

	print('Enter UVM Default test name(for example ' + project_dir + '_base_test): ', end='')
	test = input()

	init_git = False
	print('Enter \'y\' to initialize git: ', end='')
	if(input() == 'y'):
		init_git = True

	os.mkdir(project_dir)
	os.mkdir(project_dir + '/doc')
	os.mkdir(project_dir + '/ip')
	os.mkdir(project_dir + '/lint')
	os.mkdir(project_dir + '/src')
	os.mkdir(project_dir + '/tests')

	# Lint Waiver
	with open(project_dir + '/lint/waiver.vlt', 'w', encoding='utf-8') as waiver_vlt:
		waiver_vlt.write('`verilator_config\n\n')
		waiver_vlt.write('lint_off -file "ip/*"\n')

	# Source directory
	with open(project_dir + '/src/source.f', 'w', encoding='utf-8') as src_sourcef:
		src_sourcef.write("+incdir+.\n\n")
		src_sourcef.write(package_name + '.sv\n')

	with open(project_dir + '/src/' + package_name + '.sv', 'w', encoding='utf-8') as src_package_sv:
		src_package_sv.write('package ' + package_name + ';\n')
		src_package_sv.write('endpackage\n');

	# Tests directory
	with open(project_dir + '/tests/source.f', 'w', encoding='utf-8') as tests_sourcef:
		tests_sourcef.write(verif_top_name + '.sv\n')

	with open(project_dir + '/tests/' + verif_top_name + '.sv', 'w', encoding='utf-8') as verif_top_sv:
		verif_top_sv.write('module ' + verif_top_name + ';\n')
		verif_top_sv.write('endmodule\n');

	# Makefile
	with open(project_dir + '/Makefile', 'w', encoding='utf-8') as makefile_file:
		makefile_file.write('# Verification IP dependency in \'ip\' folder\n')
		makefile_file.write('IP_DEP := \n\n')
		makefile_file.write('# Verification IP dependency in same folder as current ip\n')
		makefile_file.write('REPO_DEP := \n\n')
		makefile_file.write('# Testbench top level module name\n')
		makefile_file.write('TESTS_TOP_NAME := ' + verif_top_name + '\n\n')
		makefile_file.write('# Default UVM test name\n')
		makefile_file.write('TEST := ' + test + '\n\n')
		makefile_file.write('include ip/flows/verification-ip.mk\n')

	if(init_git):
		with open(project_dir + '/.gitignore', 'w', encoding='utf-8') as gitignore_file:
			gitignore_file.write('# Temporary file lists\n')
			gitignore_file.write('vip_filelist.f\n')
			gitignore_file.write('# Simulation flow temporary files\n')
			gitignore_file.write('sim\n')

		git_proc = subprocess.Popen(['git', 'init'], cwd=project_dir)
		git_proc.wait()

		git_proc = subprocess.Popen(['git', 'submodule', 'add', 'https://github.com/tamarack-silicon/flows.git'], cwd=(project_dir + '/ip'))
		git_proc.wait()

		git_proc = subprocess.Popen(['git', 'submodule', 'add', 'https://github.com/accellera-official/uvm-core.git', 'uvm'], cwd=(project_dir + '/ip'))
		git_proc.wait()

	exit(0)

def create_digital_ip(project_dir, project_type):
	print('Enter IP name: ', end='')
	ip_name = input()

	rtl_top_name_suggestion = ip_name + '_top'
	print('Enter RTL top-level module name(for example ' + rtl_top_name_suggestion + ', enter to use example): ', end='')
	rtl_top_name = input()
	if not rtl_top_name:
		rtl_top_name = rtl_top_name_suggestion

	csr_block_name_suggestion = ip_name + '_csr'
	print('Enter CSR block name(for example ' + csr_block_name_suggestion + ', y to use example): ', end='')
	csr_block_name = input()
	if(csr_block_name == 'y'):
		csr_block_name = csr_block_name_suggestion
	if not csr_block_name:
		print('No CSR block')

	tb_name_suggestion = rtl_top_name_suggestion + '_tb'
	print('Enter default testbench name(for example ' + tb_name_suggestion + ', enter to use example): ', end='')
	tb_name = input()
	if not tb_name:
		tb_name = tb_name_suggestion

	verif_top_name_suggestion = rtl_top_name_suggestion + '_verif_tb'
	print('Enter UVM verification environment testbench top name(for example ' + verif_top_name_suggestion + ', y to use example): ', end='')
	verif_top_name = input()
	if(verif_top_name == 'y'):
		verif_top_name = verif_top_name_suggestion
	if not verif_top_name:
		print('No UVM verification environment')

	test = ''
	if verif_top_name:
		test_suggestion = ip_name + '_base_test'
		print('Enter UVM Default test name(for example ' + test_suggestion + ', enter to use example): ', end='')
		test = input()
		if not test:
			test = test_suggestion

	init_git = False
	print('Enter \'y\' to initialize git: ', end='')
	if(input() == 'y'):
		init_git = True

	os.mkdir(project_dir)
	os.mkdir(project_dir + '/csr')
	os.mkdir(project_dir + '/doc')
	os.mkdir(project_dir + '/formal')
	os.mkdir(project_dir + '/ip')
	os.mkdir(project_dir + '/lint')
	os.mkdir(project_dir + '/rtl')
	os.mkdir(project_dir + '/synth')
	os.mkdir(project_dir + '/tb')
	os.mkdir(project_dir + '/verif')
	os.mkdir(project_dir + '/verif/tests')

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
		rtl_top_sv.write('module ' + rtl_top_name + ';\n\n')
		rtl_top_sv.write('endmodule\n');

	# Testbench
	with open(project_dir + '/tb/' + tb_name + '.sv', 'w', encoding='utf-8') as tb_sv:
		tb_sv.write('module ' + tb_name + ';\n\n')
		tb_sv.write('\tinitial begin\n')
		tb_sv.write('\t\t$dumpfile("wave.vcd");\n')
		tb_sv.write('\t\t$dumpvars;\n')
		tb_sv.write('\tend\n\n')
		tb_sv.write('endmodule\n');

	# UVM Verification directory
	if verif_top_name:
		with open(project_dir + '/verif/source.f', 'w', encoding='utf-8') as verif_sourcef:
			if csr_block_name:
				verif_sourcef.write(csr_block_name + '_ral_pkg.sv\n\n')
			verif_sourcef.write(verif_top_name + '.sv\n\n')
			verif_sourcef.write('tests/' + test + '_pkg.sv\n')

		with open(project_dir + '/verif/' + verif_top_name + '.sv', 'w', encoding='utf-8') as verif_top_sv:
			verif_top_sv.write('module ' + verif_top_name + ';\n\n')
			verif_top_sv.write('\tinitial begin\n')
			verif_top_sv.write('\t\tuvm_pkg::run_test();\n')
			verif_top_sv.write('\tend\n\n')
			verif_top_sv.write('\tinitial begin\n')
			verif_top_sv.write('\t\t$dumpfile("wave.vcd");\n')
			verif_top_sv.write('\t\t$dumpvars;\n')
			verif_top_sv.write('\tend\n\n')
			verif_top_sv.write('endmodule\n');

		with open(project_dir + '/verif/tests/' + test + '_pkg.sv', 'w', encoding='utf-8') as verif_test_sv:
			verif_test_sv.write('package ' + test + '_pkg;\n\n')
			verif_test_sv.write('endpackage\n');

	with open(project_dir + '/Makefile', 'w', encoding='utf-8') as makefile_file:
		makefile_file.write('# Name of the IP block\n')
		makefile_file.write('IP_NAME := ' + ip_name + '\n\n')
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
		makefile_file.write('# RTL top level module name\n')
		makefile_file.write('RTL_TOP_NAME := ' + rtl_top_name + '\n\n')
		makefile_file.write('# Default testbench name\n')
		makefile_file.write('TB_NAME := ' + tb_name + '\n\n')
		makefile_file.write('# Testbench top level module name\n')
		makefile_file.write('VERIF_TOP_NAME := ' + verif_top_name + '\n\n')
		makefile_file.write('# Default UVM test name\n')
		makefile_file.write('TEST := ' + test + '\n\n')
		makefile_file.write('include ip/flows/' + project_type + '.mk\n')

	if(init_git):
		wget_proc = subprocess.Popen(['wget', '-O', 'COPYING', 'https://www.gnu.org/licenses/gpl-3.0.txt'], cwd=(project_dir))
		wget_proc.wait()

		with open(project_dir + '/.gitignore', 'w', encoding='utf-8') as gitignore_file:
			gitignore_file.write('# Temporary file lists\n')
			gitignore_file.write('rtl_filelist.f\n')
			gitignore_file.write('verif_filelist.f\n\n')
			gitignore_file.write('# Simulation flow temporary files\n')
			gitignore_file.write('sim\n\n')
			gitignore_file.write('# Synthesis and Implementation flow temporary files\n')
			gitignore_file.write('abc.history\n')
			gitignore_file.write('dataout\n\n')
			gitignore_file.write('# Formal verification flow temporary files\n')
			gitignore_file.write('symbiyosys.sby\n')
			gitignore_file.write('symbiyosys\n')
			gitignore_file.write('symbiyosys_bmc\n')
			gitignore_file.write('symbiyosys_cover\n')
			gitignore_file.write('symbiyosys_prove\n\n')
			gitignore_file.write('# Sphinx output directory\n')
			gitignore_file.write('_build\n')

		git_proc = subprocess.Popen(['git', 'init'], cwd=project_dir)
		git_proc.wait()

		git_proc = subprocess.Popen(['git', 'submodule', 'add', 'https://github.com/tamarack-silicon/flows.git'], cwd=(project_dir + '/ip'))
		git_proc.wait()

		if verif_top_name:
			git_proc = subprocess.Popen(['git', 'submodule', 'add', 'https://github.com/accellera-official/uvm-core.git', 'uvm'], cwd=(project_dir + '/ip'))
			git_proc.wait()

	exit(0)

def main() -> int:
	if(len(sys.argv) != 3):
		print('Usage: create-tamarack-project.py type project_dir')
		return 0

	project_type = sys.argv[1]
	project_dir = sys.argv[2]
	if(os.path.exists(project_dir)):
		print(project_dir + ' already exists')
		return 1

	if(project_type == "verification-ip"):
		create_verification_ip(project_dir)
	elif project_type in ("digital-ip", "asic-subsystem", "fpga-subsystem"):
		create_digital_ip(project_dir, project_type)
	return 0

if __name__ == '__main__':
	sys.exit(main())
